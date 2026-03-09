import 'package:hive/hive.dart';

part 'occurrence_model.g.dart';

@HiveType(typeId: 2)
class OccurrenceModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final double lat;

  @HiveField(4)
  final double lon;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final String? imagePath;

  @HiveField(7)
  final bool pendingSync;

  /// Parceiro associado (opcional)
  @HiveField(8)
  final String? partnerId;

  @HiveField(9)
  final String? partnerName;

  const OccurrenceModel({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.lat,
    required this.lon,
    this.notes,
    this.imagePath,
    this.pendingSync = false,
    this.partnerId,
    this.partnerName,
  });

  OccurrenceModel copyWith({
    String? id,
    String? type,
    DateTime? dateTime,
    double? lat,
    double? lon,
    String? notes,
    String? imagePath,
    bool? pendingSync,
    String? partnerId,
    String? partnerName,
  }) {
    return OccurrenceModel(
      id: id ?? this.id,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      pendingSync: pendingSync ?? this.pendingSync,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
    );
  }
}
