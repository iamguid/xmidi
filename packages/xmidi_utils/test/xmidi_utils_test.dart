import 'package:test/test.dart';
import 'package:xmidi_utils/xmidi_utils.dart';

void main() {
  test('midiToNote', () {
    expect(MidiUtils.midiToNote(0), 'C0');
    expect(MidiUtils.midiToNote(1), 'C#0');
    expect(MidiUtils.midiToNote(2), 'D0');
    expect(MidiUtils.midiToNote(3), 'D#0');
    expect(MidiUtils.midiToNote(4), 'E0');
    expect(MidiUtils.midiToNote(5), 'F0');
    expect(MidiUtils.midiToNote(6), 'F#0');
    expect(MidiUtils.midiToNote(7), 'G0');
    expect(MidiUtils.midiToNote(8), 'G#0');
    expect(MidiUtils.midiToNote(9), 'A0');
    expect(MidiUtils.midiToNote(10), 'A#0');
    expect(MidiUtils.midiToNote(11), 'B0');

    expect(MidiUtils.midiToNote(12), 'C1');
    expect(MidiUtils.midiToNote(13), 'C#1');
    expect(MidiUtils.midiToNote(14), 'D1');
    expect(MidiUtils.midiToNote(15), 'D#1');
    expect(MidiUtils.midiToNote(16), 'E1');
    expect(MidiUtils.midiToNote(17), 'F1');
    expect(MidiUtils.midiToNote(18), 'F#1');
    expect(MidiUtils.midiToNote(19), 'G1');
    expect(MidiUtils.midiToNote(20), 'G#1');
    expect(MidiUtils.midiToNote(21), 'A1');
    expect(MidiUtils.midiToNote(22), 'A#1');
    expect(MidiUtils.midiToNote(23), 'B1');

    expect(MidiUtils.midiToNote(24), 'C2');
  });

  test('noteToMidi', () {
    expect(MidiUtils.noteToMidi('C0'), 0);
    expect(MidiUtils.noteToMidi('C#0'), 1);
    expect(MidiUtils.noteToMidi('D0'), 2);
    expect(MidiUtils.noteToMidi('D#0'), 3);
    expect(MidiUtils.noteToMidi('E0'), 4);
    expect(MidiUtils.noteToMidi('F0'), 5);
    expect(MidiUtils.noteToMidi('F#0'), 6);
    expect(MidiUtils.noteToMidi('G0'), 7);
    expect(MidiUtils.noteToMidi('G#0'), 8);
    expect(MidiUtils.noteToMidi('A0'), 9);
    expect(MidiUtils.noteToMidi('A#0'), 10);
    expect(MidiUtils.noteToMidi('B0'), 11);

    expect(MidiUtils.noteToMidi('C1'), 12);
    expect(MidiUtils.noteToMidi('C#1'), 13);
    expect(MidiUtils.noteToMidi('D1'), 14);
    expect(MidiUtils.noteToMidi('D#1'), 15);
    expect(MidiUtils.noteToMidi('E1'), 16);
    expect(MidiUtils.noteToMidi('F1'), 17);
    expect(MidiUtils.noteToMidi('F#1'), 18);
    expect(MidiUtils.noteToMidi('G1'), 19);
    expect(MidiUtils.noteToMidi('G#1'), 20);
    expect(MidiUtils.noteToMidi('A1'), 21);
    expect(MidiUtils.noteToMidi('A#1'), 22);
    expect(MidiUtils.noteToMidi('B1'), 23);

    expect(MidiUtils.noteToMidi('C2'), 24);
  });
}
