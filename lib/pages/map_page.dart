import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../themes/app_colors.dart';
import '../data/models/occurrence_model.dart';
import '../data/models/partner_model.dart';

import 'occurrences_page.dart';
import 'partners_page.dart';
import 'new_occurrence_page.dart';

class MapPage extends StatefulWidget {
  final Box<OccurrenceModel> occBox;
  final Box<PartnerModel> partnersBox;

  const MapPage({
    super.key,
    required this.occBox,
    required this.partnersBox,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    final occCount = widget.occBox.length;
    final partnersCount = widget.partnersBox.length;

    return Scaffold(
      backgroundColor: AppColors.lilacLight,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        title: const Text('Mapa RuaViva'),
        actions: [
          IconButton(
            tooltip: 'Ocorrências',
            icon: const Icon(Icons.receipt_long),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OccurrencesPage(
                    occBox: widget.occBox, // ✅
                    partnersBox: widget.partnersBox, // ✅
                  ),
                ),
              );
              if (!mounted) return;
              setState(() {});
            },
          ),
          IconButton(
            tooltip: 'Parceiros',
            icon: const Icon(Icons.groups),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PartnersPage(
                    partnersBox: widget.partnersBox, // ✅ nada de box:
                  ),
                ),
              );
              if (!mounted) return;
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Mapa de ocorrências',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    label: 'Ocorrências',
                    value: occCount.toString(),
                    icon: Icons.location_on,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _InfoCard(
                    label: 'Parceiros',
                    value: partnersCount.toString(),
                    icon: Icons.groups,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Aqui entra o mapa (Google Maps / Flutter Map)\n'
                    'para selecionar o ponto da ocorrência.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.purple,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NewOccurrencePage(
                box: widget.occBox,
              ),
            ),
          );
          if (!mounted) return;
          setState(() {});
        },
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Nova ocorrência'),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.purple),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
