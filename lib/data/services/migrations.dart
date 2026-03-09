// lib/data/services/migrations.dart
import 'package:hive_flutter/hive_flutter.dart';

import '../models/partner_model.dart';
import '../models/occurrence_model.dart';

/// Executa migrações simples nos dados armazenados no Hive.
/// Hoje só garante que todos os registros tenham um id.
Future<void> runMigrations(
  Box<PartnerModel> partnersBox,
  Box<OccurrenceModel> occBox,
) async {
  // Migração de parceiros
  for (final key in partnersBox.keys) {
    final p = partnersBox.get(key);
    if (p == null) continue;

    if (p.id.isEmpty) {
      final updated = p.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      await partnersBox.put(key, updated);
    }
  }

  // Migração de ocorrências
  for (final key in occBox.keys) {
    final o = occBox.get(key);
    if (o == null) continue;

    if (o.id.isEmpty) {
      final updated = o.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      await occBox.put(key, updated);
    }
  }
}
