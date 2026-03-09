import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../themes/app_colors.dart';
import '../data/models/occurrence_model.dart';
import '../data/models/partner_model.dart';

import 'partners_page.dart';
import 'occurrences_page.dart';

class HomePage extends StatelessWidget {
  final Box<OccurrenceModel> occBox;
  final Box<PartnerModel> partnersBox;

  const HomePage({
    super.key,
    required this.occBox,
    required this.partnersBox,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lilacLight,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        centerTitle: true,
        title: const Text(
          'RuaViva',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/logo_ruaviva.png',
                height: 160,
              ),
              const SizedBox(height: 24),
              const Text(
                'Conectando solidariedade às ruas 💜',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.purple,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Selecione abaixo o que deseja acessar:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 32),
              // Botões principais
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PartnersPage(
                              partnersBox: partnersBox,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.groups, color: Colors.white),
                      label: const Text(
                        'Ver parceiros',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OccurrencesPage(
                              occBox: occBox, // ✅ nome correto
                              partnersBox: partnersBox, // ✅ nome correto
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long, color: Colors.white),
                      label: const Text(
                        'Ver ocorrências',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Versão 1.0.0',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
