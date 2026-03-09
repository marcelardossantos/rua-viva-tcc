// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartnerModelAdapter extends TypeAdapter<PartnerModel> {
  @override
  final int typeId = 2;

  @override
  PartnerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartnerModel(
      id: fields[0] as String,
      name: fields[1] as String,
      org: fields[2] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      lat: fields[5] as double,
      lon: fields[6] as double,
      tags: (fields[7] as List).cast<String>(),
      active: fields[8] == null ? true : fields[8] as bool,
      radiusKm: fields[9] == null ? 5.0 : fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PartnerModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.org)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.lat)
      ..writeByte(6)
      ..write(obj.lon)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.active)
      ..writeByte(9)
      ..write(obj.radiusKm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
