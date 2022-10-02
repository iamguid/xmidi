import 'package:xmidi_rw/xmidi_rw.dart';

class TrackPlayerEvent {
  final int tick;
  final int timeMs;
  final MidiEvent midiEvent;

  TrackPlayerEvent({
    required this.timeMs,
    required this.tick,
    required this.midiEvent,
  });
}

class TrackPlayer {
  final List<MidiEvent> midiEvents;

  TrackPlayer(this.midiEvents);

  int _currentEventIndex = 0;
  int _currentEventTick = 0;

  TrackPlayerEvent? nextUpcomingEvent(
      int currentTimeMs, num millisecondsInTick) {
    if (_currentEventIndex >= midiEvents.length) {
      return null;
    }

    final currentEvent = midiEvents[_currentEventIndex];
    final currentEventTimeMs =
        ((currentEvent.deltaTime + _currentEventTick) * millisecondsInTick)
            .floor();

    if (currentEventTimeMs > currentTimeMs) {
      return null;
    }

    _currentEventTick += currentEvent.deltaTime;

    final currentTrackPlayerEvent = TrackPlayerEvent(
      timeMs: (currentEvent.deltaTime * millisecondsInTick).floor(),
      tick: _currentEventTick,
      midiEvent: currentEvent,
    );

    _currentEventIndex++;

    return currentTrackPlayerEvent;
  }

  void reset() {
    _currentEventIndex = 0;
    _currentEventTick = 0;
  }
}
