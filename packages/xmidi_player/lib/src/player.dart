import 'dart:async';

import 'package:xmidi_rw/xmidi_rw.dart';

import 'track_player.dart';

enum MidiPlayerStatus { play, stop, pause, end }

class MidiPlayer {
  /// Sample rate in milliseconds that used by default
  /// That sample rate based on "average" ppq (96) and "average" bpm (120)
  /// 60 / 120 = 0.5 seconds per beat
  /// 500ms / 96 = 5.208333ms per clock tick.
  static const _sampleRateMs = 5;

  /// Default tempo in bpm that used until set tempo midi event
  static const _defaultTempoBpm = 120.0;

  /// Current tempo in bpm that used until set tempo midi event or setTempo
  num _currentTempoBpm = MidiPlayer._defaultTempoBpm;

  /// Indicates is player in playing state or not
  bool _isPlaying = false;
  get isPlaying => _isPlaying;

  /// Indicates is player in paused state or not
  bool _isPaused = false;
  get isPaused => _isPaused;

  /// Indicates is player in stopped state or not
  bool _isStopped = true;
  get isStopped => _isStopped;

  /// Total ticks in file
  int _totalTicks = 0;

  /// Total events in file
  int _totalEvents = 0;

  /// Stream controller where put playable midi events
  final StreamController<MidiEvent> _midiEventsSC =
      StreamController.broadcast();

  late Stream<MidiEvent> midiEventsStream = _midiEventsSC.stream;

  /// Stream controller where put play status
  final StreamController<MidiPlayerStatus> _statusEventsSC =
      StreamController.broadcast();

  late Stream<MidiPlayerStatus> statusStream = _statusEventsSC.stream;

  /// Stream controller where put each tick
  final StreamController<int> _ticksEventsSC = StreamController.broadcast();

  late Stream<int> ticksStream = _ticksEventsSC.stream;

  /// Loaded midi file
  MidiFile? _file;

  /// Prepared track players
  final List<TrackPlayer> _tracks = [];

  /// Timer that counts track time from beginning to end
  Stopwatch? _playbackTimer;

  /// Offset that used for in fly bpm change
  int _bpmChangeTimeOffsetMs = 0;

  /// Offset that used by users
  int timeOffsetMs = 0;

  /// Periodic timer that calls [_playLoop] once at [_sampleRateMs]
  Timer? _loopTimer;

  /// Count all events
  int _processedEventsCount = 0;

  /// Returns current time of track in milliseconds
  int get currentTimeMs {
    if (_playbackTimer == null) {
      return timeOffsetMs;
    }

    return _playbackTimer!.elapsed.inMilliseconds +
        _bpmChangeTimeOffsetMs +
        timeOffsetMs;
  }

  /// Returns current tick
  int get currentTick {
    return (currentTimeMs / millisecondsPerTick).floor();
  }

  /// Returns total number of ticks in the loaded MIDI file
  int get totalTicks {
    return _totalTicks;
  }

  /// Progress from 0 to 1
  num get currentProgress {
    return 1 / totalTicks * currentTick;
  }

  /// Gets total number of events in the loaded MIDI file.
  int get totalEvents {
    return _totalEvents;
  }

  /// Events getter.
  List<MidiEvent> get events {
    return _tracks.fold<List<MidiEvent>>([], (previousValue, element) {
      previousValue.addAll(element.midiEvents);
      return previousValue;
    });
  }

  set tempo(num tempo) {
    final currentMillisecondsPerTick = millisecondsPerTick;
    final currentTicks = currentTimeMs / currentMillisecondsPerTick;
    final currentTicksMs = currentTicks * currentMillisecondsPerTick;

    _currentTempoBpm = tempo;

    final newMillisecondsPerTicks = millisecondsPerTick;
    final newTicks = currentTimeMs / newMillisecondsPerTicks;
    final newTicksMs = newTicks * currentMillisecondsPerTick;

    _bpmChangeTimeOffsetMs = (newTicksMs - currentTicksMs).floor();
  }

  /// The main loop that calls each [_currentSampleRateMs]
  void _playLoop(Timer _) {
    for (var track in _tracks) {
      while (true) {
        final upcomingEvent =
            track.nextUpcomingEvent(currentTimeMs, millisecondsPerTick);

        if (upcomingEvent == null) {
          break;
        }

        final midiEvent = upcomingEvent.midiEvent;

        _midiEventsSC.add(midiEvent);

        _processedEventsCount++;
      }
    }

    _ticksEventsSC.add(currentTick);

    if (_processedEventsCount >= totalEvents) {
      stop();
      _statusEventsSC.add(MidiPlayerStatus.end);
    }
  }

  num get millisecondsPerTick {
    if (_file!.header.ticksPerBeat != null) {
      return 60000 / (_file!.header.ticksPerBeat! * _currentTempoBpm);
    } else {
      return 60000 /
          (_file!.header.framesPerSecond! *
              _file!.header.ticksPerFrame! *
              _currentTempoBpm);
    }
  }

  /// Loads `xmidi_rw` MidiFile
  void load(MidiFile file) {
    _file = file;

    _totalEvents = 0;
    _totalTicks = 0;

    for (var events in file.tracks) {
      _tracks.add(TrackPlayer(events));

      for (var event in events) {
        _totalEvents++;
        _totalTicks += event.deltaTime;
      }
    }
  }

  /// Pause midi player
  void pause() {
    if (!isPlaying || isPaused) return;

    // Stop timer
    _playbackTimer!.stop();

    // Stop looping
    _loopTimer!.cancel();

    _isPlaying = false;
    _isPaused = true;
    _isStopped = false;

    _statusEventsSC.add(MidiPlayerStatus.pause);
  }

  /// Stop midi player and reset state
  void stop() {
    if (!isPlaying || isStopped) return;

    // Reset events counter
    _processedEventsCount = 0;

    // Reset track players
    for (var track in _tracks) {
      track.reset();
    }

    // Stop looping
    _loopTimer!.cancel();

    // Stop and reset timer
    _playbackTimer!
      ..stop()
      ..reset();

    _isPlaying = false;
    _isPaused = false;
    _isStopped = true;

    _statusEventsSC.add(MidiPlayerStatus.stop);
  }

  /// Start playing from begin
  void play() {
    if (isPlaying) return;

    if (!isPaused) {
      _playbackTimer ??= Stopwatch();
    }

    _playbackTimer!.start();

    // Start loop
    _loopTimer =
        Timer.periodic(const Duration(milliseconds: _sampleRateMs), _playLoop);

    _isPlaying = true;
    _isPaused = false;
    _isStopped = false;

    _statusEventsSC.add(MidiPlayerStatus.play);
  }
}
