// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiKeyModelAdapter extends TypeAdapter<ApiKeyModel> {
  @override
  final int typeId = 0;

  @override
  ApiKeyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiKeyModel(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApiKeyModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiKeyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
