import 'package:xmidi_utils/xmidi_utils.dart';

void main() {
  final note = MidiUtils.midiToNote(12);
  final midi = MidiUtils.noteToMidi('C1');

  print('note: $note, midi: $midi');
}
