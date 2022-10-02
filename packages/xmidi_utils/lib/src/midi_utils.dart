class MidiUtils {
  static final noteRegex = RegExp(r'^([C|D|E|F|G|A|B]#?)(\d+)$');

  static final chromatic = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  /// Get the note name (in scientific notation) of the given midi number
  /// where C1 is 12
  ///
  /// This method doesn't take into account diatonic spelling. Always the same
  /// pitch class is given for the same midi number.
  static String midiToNote(int midi) {
    var name = MidiUtils.chromatic[midi % 12];
    var oct = (midi / 12).floor();
    return '$name$oct';
  }

  static int noteToMidi(String note) {
    final parsed = MidiUtils.noteRegex.firstMatch(note);

    if (parsed == null || parsed.groupCount != 2) {
      throw Exception("Invalid note format");
    }

    final chromatic = parsed.group(1)!;
    final oct = int.parse(parsed.group(2)!);
    final chromaticIndex = MidiUtils.chromatic.indexOf(chromatic);

    return chromaticIndex + oct * 12;
  }
}
