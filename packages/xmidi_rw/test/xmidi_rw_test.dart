import 'dart:io';

import 'package:test/test.dart';
import 'package:xmidi_rw/xmidi_rw.dart';

void main() {
  test('reader and writer output matches', () {
    final file = File('test/data/miditrack.mid');

    final reader = MidiReader();
    List<int> originalFileBuffer = file.readAsBytesSync();
    final parsedMidi = reader.parseMidiFromBuffer(originalFileBuffer);

    final writer = MidiWriter();
    List<int> writtenBuffer = writer.writeMidiToBuffer(parsedMidi);

    expect(originalFileBuffer, writtenBuffer);
  });
}
