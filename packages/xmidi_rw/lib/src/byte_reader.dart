import 'data_chunk.dart';

class ByteReader {
  final List<int> buffer;
  int pos = 0;
  bool get eof => pos >= buffer.length;

  ByteReader(this.buffer);

  int readUInt8() {
    var result = buffer[pos];
    pos += 1;
    return result;
  }

  int readInt8() {
    var u = readUInt8();
    if (u & 0x80 != 0) {
      return u - 0x100;
    } else {
      return u;
    }
  }

  int readUInt16() {
    var b0 = readUInt8();
    var b1 = readUInt8();
    return (b0 << 8) + b1;
  }

  int readInt16() {
    var u = readUInt16();
    if (u & 0x8000 != 0) {
      return u - 0x10000;
    } else
      return u;
  }

  int readUInt24() {
    var b0 = readUInt8();
    var b1 = readUInt8();
    var b2 = readUInt8();
    return (b0 << 16) + (b1 << 8) + b2;
  }

  int readInt24() {
    var u = readUInt16();
    if (u & 0x800000 != 0) {
      return u - 0x1000000;
    } else {
      return u;
    }
  }

  int readUInt32() {
    var b0 = readUInt8();
    var b1 = readUInt8();
    var b2 = readUInt8();
    var b3 = readUInt8();

    return (b0 << 24) + (b1 << 16) + (b2 << 8) + b3;
  }

  List<int> readBytes(int len) {
    var bytes = buffer.sublist(pos, pos + len);
    pos += len;
    return bytes;
  }

  String readString(int len) {
    var bytes = readBytes(len);
    return String.fromCharCodes(bytes);
  }

  int readVarInt() {
    var result = 0;
    while (!eof) {
      var b = readUInt8();
      if (b & 0x80 != 0) {
        result += (b & 0x7f);
        result <<= 7;
      } else {
        // b is last byte
        return result + b;
      }
    }
    // premature eof
    return result;
  }

  DataChunk readChunk() {
    var id = readString(4);
    var length = readUInt32();
    var data = readBytes(length);
    return DataChunk(id: id, length: length, bytes: data);
  }
}
