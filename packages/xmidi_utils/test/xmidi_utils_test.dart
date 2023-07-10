import 'package:test/test.dart';
import 'package:xmidi_utils/xmidi_utils.dart';

void main() {
  test('midiToNote', () {
    expect(MidiUtils.midiToNote(24), 'C0');
    expect(MidiUtils.midiToNote(25), 'C#0');
    expect(MidiUtils.midiToNote(26), 'D0');
    expect(MidiUtils.midiToNote(27), 'D#0');
    expect(MidiUtils.midiToNote(28), 'E0');
    expect(MidiUtils.midiToNote(29), 'F0');
    expect(MidiUtils.midiToNote(30), 'F#0');
    expect(MidiUtils.midiToNote(31), 'G0');
    expect(MidiUtils.midiToNote(32), 'G#0');
    expect(MidiUtils.midiToNote(33), 'A0');
    expect(MidiUtils.midiToNote(34), 'A#0');
    expect(MidiUtils.midiToNote(35), 'B0');

    expect(MidiUtils.midiToNote(36), 'C1');
    expect(MidiUtils.midiToNote(37), 'C#1');
    expect(MidiUtils.midiToNote(38), 'D1');
    expect(MidiUtils.midiToNote(39), 'D#1');
    expect(MidiUtils.midiToNote(40), 'E1');
    expect(MidiUtils.midiToNote(41), 'F1');
    expect(MidiUtils.midiToNote(42), 'F#1');
    expect(MidiUtils.midiToNote(43), 'G1');
    expect(MidiUtils.midiToNote(44), 'G#1');
    expect(MidiUtils.midiToNote(45), 'A1');
    expect(MidiUtils.midiToNote(46), 'A#1');
    expect(MidiUtils.midiToNote(47), 'B1');

    expect(MidiUtils.midiToNote(48), 'C2');
  });

  test('noteToMidi', () {
    expect(MidiUtils.noteToMidi('C0'), 24);
    expect(MidiUtils.noteToMidi('C#0'), 25);
    expect(MidiUtils.noteToMidi('D0'), 26);
    expect(MidiUtils.noteToMidi('D#0'), 27);
    expect(MidiUtils.noteToMidi('E0'), 28);
    expect(MidiUtils.noteToMidi('F0'), 29);
    expect(MidiUtils.noteToMidi('F#0'), 30);
    expect(MidiUtils.noteToMidi('G0'), 31);
    expect(MidiUtils.noteToMidi('G#0'), 32);
    expect(MidiUtils.noteToMidi('A0'), 33);
    expect(MidiUtils.noteToMidi('A#0'), 34);
    expect(MidiUtils.noteToMidi('B0'), 35);

    expect(MidiUtils.noteToMidi('C1'), 36);
    expect(MidiUtils.noteToMidi('C#1'), 37);
    expect(MidiUtils.noteToMidi('D1'), 38);
    expect(MidiUtils.noteToMidi('D#1'), 39);
    expect(MidiUtils.noteToMidi('E1'), 40);
    expect(MidiUtils.noteToMidi('F1'), 41);
    expect(MidiUtils.noteToMidi('F#1'), 42);
    expect(MidiUtils.noteToMidi('G1'), 43);
    expect(MidiUtils.noteToMidi('G#1'), 44);
    expect(MidiUtils.noteToMidi('A1'), 45);
    expect(MidiUtils.noteToMidi('A#1'), 46);
    expect(MidiUtils.noteToMidi('B1'), 47);

    expect(MidiUtils.noteToMidi('C2'), 48);
  });
}
