import 'dart:math';
import 'package:hive/hive.dart';

part 'partner.g.dart';

@HiveType(typeId: 2)
class PartnerModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String org;

  @HiveField(3)
  String email;

  @HiveField(4)
  String phone;

  @HiveField(5)
  double lat;

  @HiveField(6)
  double lon;

  @HiveField(7)
  List<String> tags;

  @HiveField(8, defaultValue: true)
  bool active;

  @HiveField(9, defaultValue: 5.0)
  double radiusKm;

  PartnerModel({
    required this.id,
    required this.name,
    required this.org,
    required this.email,
    required this.phone,
    required this.lat,
    required this.lon,
    required this.tags,
    this.active = true,
    this.radiusKm = 5.0,
  });

  /// Exibe org + tags resumidas para listar
  String get shortInfo => '$org • ${tags.join(", ")}';

  /// Link pronto para WhatsApp
  String get whatsappUrl {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final text = Uri.encodeComponent('Olá $name, tudo bem?');
    return 'https://wa.me/$digits?text=$text';
  }

  /// URI mailto simples
  String get emailUri =>
      'mailto:$email?subject=${Uri.encodeComponent("Contato")}';

  /// Distância aproximada até um ponto (km)
  double distanceKmTo(double lat2, double lon2) {
    const r = 6371.0; // km
    final dLat = _deg2rad(lat2 - lat);
    final dLon = _deg2rad(lon2 - lon);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  copyWith({required String id}) {}
}

double _deg2rad(double deg) => deg * (pi / 180.0);
