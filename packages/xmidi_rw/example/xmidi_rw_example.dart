import 'dart:io';

import 'package:xmidi_rw/xmidi_rw.dart';

void main() {
  // Open a file containing midi data
  var file = File('sample_midi.mid');

  // Construct a midi reader
  var reader = MidiReader();

  // Parse midi directly from file. You can also use parseMidiFromBuffer to directly parse List<int>
  MidiFile parsedMidi = reader.parseMidiFromFile(file);

  // You can now access your parsed [MidiFile]
  print(parsedMidi.tracks.length.toString());

  // Construct a midi writer
  var writer = MidiWriter();

  // Let's write and encode our midi data again
  // You can also control `running` flag to compress file and  `useByte9ForNoteOff` to use 0x09 for noteOff when velocity is zero
  writer.writeMidiToFile(parsedMidi, File('output.mid'));
}
