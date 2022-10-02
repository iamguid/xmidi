class DataChunk {
  final String id;
  final int? length;
  final List<int> bytes;

  DataChunk({
    required this.id,
    required this.bytes,
    this.length,
  });
}
