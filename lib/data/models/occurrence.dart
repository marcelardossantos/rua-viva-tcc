import 'package:hive/hive.dart';

part 'occurrence.g.dart';

@HiveType(typeId: 1)
class OccurrenceModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double lat;

  @HiveField(2)
  double lon;

  @HiveField(3)
  DateTime dateTime;

  @HiveField(4)
  String type; // pessoa/grupo/acampamento/risco

  @HiveField(5)
  String notes;

  @HiveField(6)
  String? imagePath;

  @HiveField(7)
  bool pendingSync; // true = precisa enviar à API

  OccurrenceModel({
    required this.id,
    required this.lat,
    required this.lon,
    required this.dateTime,
    required this.type,
    required this.notes,
    this.imagePath,
    this.pendingSync = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'lat': lat,
        'lon': lon,
        'dateTime': dateTime.toIso8601String(),
        'type': type,
        'notes': notes,
        'imagePath': imagePath,
      };

  factory OccurrenceModel.fromJson(Map<String, dynamic> j) => OccurrenceModel(
        id: j['id'] as String,
        lat: (j['lat'] as num).toDouble(),
        lon: (j['lon'] as num).toDouble(),
        dateTime: DateTime.parse(j['dateTime'] as String),
        type: (j['type'] ?? 'pessoa') as String,
        notes: (j['notes'] ?? '') as String,
        imagePath: j['imagePath'] as String?,
        pendingSync: false,
      );

  copyWith({required String id}) {}
}
