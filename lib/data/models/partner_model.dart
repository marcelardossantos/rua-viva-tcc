import 'package:hive/hive.dart';

part 'partner_model.g.dart';

@HiveType(typeId: 1)
class PartnerModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String org;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final double lat;

  @HiveField(6)
  final double lon;

  @HiveField(7)
  final List<String> tags;

  @HiveField(8)
  final bool active;

  @HiveField(9)
  final String loginId;

  @HiveField(10)
  final String password;

  const PartnerModel({
    required this.id,
    required this.name,
    required this.org,
    required this.email,
    required this.phone,
    required this.lat,
    required this.lon,
    required this.tags,
    required this.active,
    required this.loginId,
    required this.password,
  });

  /// Usado em várias telas (incluindo ConnectPage)
  String get displayTitle {
    final trimmedOrg = org.trim();
    if (trimmedOrg.isEmpty) return name;
    return '$name ($trimmedOrg)';
  }

  /// Texto curto para listas
  String get shortInfo {
    if (tags.isNotEmpty) {
      return '$name — ${tags.first}';
    }
    return name;
  }

  PartnerModel copyWith({
    String? id,
    String? name,
    String? org,
    String? email,
    String? phone,
    double? lat,
    double? lon,
    List<String>? tags,
    bool? active,
    String? loginId,
    String? password,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      org: org ?? this.org,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      tags: tags ?? this.tags,
      active: active ?? this.active,
      loginId: loginId ?? this.loginId,
      password: password ?? this.password,
    );
  }
}
