import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/partner_model.dart';
import 'data/models/occurrence_model.dart';

import 'pages/map_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // registra adapters (ajuste os typeId se for diferente aí no seu projeto)
  try {
    Hive.registerAdapter(PartnerModelAdapter());
  } catch (_) {}
  try {
    Hive.registerAdapter(OccurrenceModelAdapter());
  } catch (_) {}

  final partnersBox = await Hive.openBox<PartnerModel>('partners_box');
  final occBox = await Hive.openBox<OccurrenceModel>('occurrences_box');

  runApp(SeedTestApp(
    partnersBox: partnersBox,
    occBox: occBox,
  ));
}

class SeedTestApp extends StatelessWidget {
  final Box<PartnerModel> partnersBox;
  final Box<OccurrenceModel> occBox;

  const SeedTestApp({
    super.key,
    required this.partnersBox,
    required this.occBox,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuaViva Seed Test',
      debugShowCheckedModeBanner: false,
      home: MapPage(
        occBox: occBox,
        partnersBox: partnersBox,
      ),
    );
  }
}
