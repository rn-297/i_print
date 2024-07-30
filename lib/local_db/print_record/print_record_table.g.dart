// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_record_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrintRecordModelAdapter extends TypeAdapter<PrintRecordModel> {
  @override
  final int typeId = 1;

  @override
  PrintRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrintRecordModel(
      fields[0] as int,
      (fields[1] as List).cast<Uint8List>(),
      fields[2] as DateTime,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PrintRecordModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageData)
      ..writeByte(2)
      ..write(obj.printTime)
      ..writeByte(3)
      ..write(obj.noOfCopies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrintRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
