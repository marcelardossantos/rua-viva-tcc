// lib/main_semente_local.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/occurrence_model.dart';
import 'data/models/partner_model.dart';

import 'pages/map_page.dart';
import 'data/seeds/seed_partners.dart'; // OK
// REMOVIDO: import 'data/seeds/seed_occurrences.dart'; // não existe

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Adapters (certifique que os *.g.dart já foram gerados)
  Hive.registerAdapter(OccurrenceModelAdapter());
  Hive.registerAdapter(PartnerModelAdapter());

  // Abre as boxes (tipadas)
  final occBox = await Hive.openBox<OccurrenceModel>('occurrences_box');
  final partnersBox = await Hive.openBox<PartnerModel>('partners_box');

  // Seeds (somente se estiverem vazias)
  await seedPartners(partnersBox);
  // REMOVIDO: await seedOccurrences(occBox); // se quiser, crie depois um seed para ocorrências

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MapPage(
      occBox: occBox,
      partnersBox: partnersBox,
    ),
  ));
}
