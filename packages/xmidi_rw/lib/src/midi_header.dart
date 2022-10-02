class MidiHeader {
  final int numTracks;
  final int format;
  final int? framesPerSecond;
  final int? ticksPerBeat;
  final int? ticksPerFrame;
  final int? timeDivision;

  MidiHeader({
    required this.format,
    required this.numTracks,
    this.framesPerSecond,
    this.ticksPerBeat,
    this.ticksPerFrame,
    this.timeDivision,
  });
}
