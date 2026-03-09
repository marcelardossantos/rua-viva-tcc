// lib/app.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'themes/app_colors.dart';

// MODELOS
import 'data/models/occurrence_model.dart';
import 'data/models/partner_model.dart';

// SEED
import 'data/seeds/seed_partners.dart';

// PÁGINAS
import 'pages/map_page.dart';

/// Nomes das boxes
const kOccBoxName = 'occurrences_box';
const kPartnersBoxName = 'partners_box';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late Box<OccurrenceModel> _occBox;
  late Box<PartnerModel> _partnersBox;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(OccurrenceModelAdapter());
      Hive.registerAdapter(PartnerModelAdapter());

      _occBox = await Hive.openBox<OccurrenceModel>(kOccBoxName);
      _partnersBox = await Hive.openBox<PartnerModel>(kPartnersBoxName);

      await seedPartners(_partnersBox);

      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Erro ao inicializar Hive: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(height: 12),
                Text('Inicializando Hive...'),
              ],
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text(_error!),
          ),
        ),
      );
    }

    // App pronto
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.purple,
        ).copyWith(
          primary: AppColors.purple,
          secondary: AppColors.blueLight,
          surface: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.lilacLight,
      ),
      home: MapPage(
        occBox: _occBox,
        partnersBox: _partnersBox,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
