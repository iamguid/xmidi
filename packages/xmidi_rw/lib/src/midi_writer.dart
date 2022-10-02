import 'dart:io';

import 'byte_writer.dart';
import 'data_chunk.dart';
import 'midi_events.dart';
import 'midi_file.dart';
import 'midi_header.dart';

class MidiWriter {
  MidiWriter();

  /// Converts a [MidiFile] to byte buffer represented by [List<int>]
  ///
  /// [running] reuse previous eventTypeByte when possible, to compress file
  /// [useByte9ForNoteOff] use 0x09 for noteOff when velocity is zero
  List<int> writeMidiToBuffer(
    MidiFile file, {
    bool running = false,
    bool useByte9ForNoteOff = false,
  }) {
    var w = ByteWriter();
    writeHeader(w, file.header, file.tracks.length);

    for (var f in file.tracks) {
      writeTrack(w, f);
    }

    return w.buffer;
  }

  /// Writes [midiFile] as bytes into a provided [file]
  ///
  /// [running] reuse previous eventTypeByte when possible, to compress file
  /// [useByte9ForNoteOff] use 0x09 for noteOff when velocity is zero
  void writeMidiToFile(MidiFile midiFile, File file,
      {bool running = false, bool useByte9ForNoteOff = false}) {
    var bytes = writeMidiToBuffer(midiFile);
    file.writeAsBytesSync(bytes);
  }

  /// Writes a midi track
  void writeTrack(
    ByteWriter w,
    List<MidiEvent> track, {
    bool running = false,
    bool useByte9ForNoteOff = false,
  }) {
    var t = ByteWriter();
    int i, len = track.length;
    int? eventTypeByte;
    for (i = 0; i < len; i++) {
      // Reuse last eventTypeByte when opts.running is set, or event.running is explicitly set on it.
      // parseMidi will set event.running for each event, so that we can get an exact copy by default.
      // Explicitly set opts.running to false, to override event.running and never reuse last eventTypeByte.
      if (running == false || !running && !track[i].isRunning) {
        eventTypeByte = null;
      }

      var event = track[i];
      event.lastEventTypeByte = eventTypeByte;
      event.useByte9ForNoteOff = useByte9ForNoteOff;

      t.writeVarInt(event.deltaTime);
      eventTypeByte = event.writeEvent(t);
    }

    w.writeChunk(DataChunk(id: 'MTrk', bytes: t.buffer));
  }

  /// Writes provided [header] into [w]
  void writeHeader(ByteWriter w, MidiHeader header, int numTracks) {
    int format = header.format;

    var timeDivision = 128;
    if (header.timeDivision != null) {
      timeDivision = header.timeDivision!;
    } else if (header.ticksPerFrame != null && header.framesPerSecond != null) {
      timeDivision = (-(header.framesPerSecond! & 0xFF) << 8) |
          (header.ticksPerFrame! & 0xFF);
    } else if (header.ticksPerBeat != null && header.ticksPerBeat != 0) {
      timeDivision = header.ticksPerBeat! & 0x7FFF;
    }

    var h = ByteWriter();
    h.writeUInt16(format);
    h.writeUInt16(numTracks);
    h.writeUInt16(timeDivision);

    w.writeChunk(DataChunk(id: 'MThd', bytes: h.buffer));
  }
}
