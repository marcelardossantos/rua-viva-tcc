// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'occurrence_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OccurrenceModelAdapter extends TypeAdapter<OccurrenceModel> {
  @override
  final int typeId = 2;

  @override
  OccurrenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return OccurrenceModel(
      id: fields[0] as String,
      type: fields[1] as String,
      dateTime: fields[2] as DateTime,
      lat: fields[3] as double,
      lon: fields[4] as double,
      notes: fields[5] as String?,
      imagePath: fields[6] as String?,
      pendingSync: (fields[7] as bool?) ?? false,
      partnerId: fields[8] as String?,
      partnerName: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OccurrenceModel obj) {
    writer
      ..writeByte(10) // 0..9
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.lon)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.pendingSync)
      ..writeByte(8)
      ..write(obj.partnerId)
      ..writeByte(9)
      ..write(obj.partnerName);
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
