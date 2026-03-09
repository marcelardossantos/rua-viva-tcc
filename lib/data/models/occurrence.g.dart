// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occurrence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OccurrenceModelAdapter extends TypeAdapter<OccurrenceModel> {
  @override
  final int typeId = 1;

  @override
  OccurrenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OccurrenceModel(
      id: fields[0] as String,
      lat: fields[1] as double,
      lon: fields[2] as double,
      dateTime: fields[3] as DateTime,
      type: fields[4] as String,
      notes: fields[5] as String,
      imagePath: fields[6] as String?,
      pendingSync: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OccurrenceModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.lon)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.pendingSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OccurrenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
