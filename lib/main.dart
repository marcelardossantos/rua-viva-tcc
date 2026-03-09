import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/partner_model.dart';
import 'data/models/occurrence_model.dart';
import 'data/seeds/seed_partners.dart';
import 'pages/home_page.dart';
import 'themes/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive
  await Hive.initFlutter();

  // Registra adapters (se já tiver registrado, o try/catch evita crash)
  try {
    Hive.registerAdapter(PartnerModelAdapter());
  } catch (_) {}
  try {
    Hive.registerAdapter(OccurrenceModelAdapter());
  } catch (_) {}

  // Abre as boxes (banco local)
  final partnersBox = await Hive.openBox<PartnerModel>('partners_box');
  final occBox = await Hive.openBox<OccurrenceModel>('occurrences_box');

  // Se a box de parceiros estiver vazia, cria alguns parceiros de exemplo
  await seedPartners(partnersBox);

  runApp(
    RuaVivaApp(
      partnersBox: partnersBox,
      occBox: occBox,
    ),
  );
}

class RuaVivaApp extends StatelessWidget {
  final Box<PartnerModel> partnersBox;
  final Box<OccurrenceModel> occBox;

  const RuaVivaApp({
    super.key,
    required this.partnersBox,
    required this.occBox,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rua Viva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.purple,
          primary: AppColors.purple,
          secondary: AppColors.lightPurple,
          surface: AppColors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightPurple,
      ),
      home: HomePage(
        partnersBox: partnersBox,
        occBox: occBox,
      ),
    );
  }
}
