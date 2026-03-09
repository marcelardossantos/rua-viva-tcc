// lib/pages/indicators_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/occurrence_model.dart';
import '../data/models/partner_model.dart';

class IndicatorsPage extends StatelessWidget {
  final Box<OccurrenceModel> occBox;
  final Box<PartnerModel> partnersBox;

  const IndicatorsPage({
    super.key,
    required this.occBox,
    required this.partnersBox,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indicadores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        // Primeiro “ouve” mudanças em ocorrências
        child: ValueListenableBuilder(
          valueListenable: occBox.listenable(),
          builder: (context, Box<OccurrenceModel> obox, _) {
            final totalOcc = obox.length;

            // definimos “pendente” como ocorrência sem notas (ajuste se quiser outro critério)
            final pendingOcc = obox.values
                .where((o) => (o.notes == null || o.notes!.trim().isEmpty))
                .length;

            final withNotes = totalOcc - pendingOcc;

            // Depois “ouve” mudanças em parceiros
            return ValueListenableBuilder(
              valueListenable: partnersBox.listenable(),
              builder: (context, Box<PartnerModel> pbox, __) {
                final totalPartners = pbox.length;
                final activePartners =
                    pbox.values.where((p) => p.active == true).length;
                final inactivePartners = totalPartners - activePartners;

                return ListView(
                  children: [
                    const _SectionTitle('Ocorrências'),
                    _MetricTile(
                      label: 'Total de ocorrências',
                      value: totalOcc,
                      icon: Icons.pin_drop_outlined,
                    ),
                    _MetricTile(
                      label: 'Com observações',
                      value: withNotes,
                      icon: Icons.sticky_note_2_outlined,
                    ),
                    _MetricTile(
                      label: 'Sem observações (pendentes)',
                      value: pendingOcc,
                      icon: Icons.pending_outlined,
                    ),
                    const SizedBox(height: 16),
                    const _SectionTitle('Parceiros'),
                    _MetricTile(
                      label: 'Total de parceiros',
                      value: totalPartners,
                      icon: Icons.groups_outlined,
                    ),
                    _MetricTile(
                      label: 'Ativos',
                      value: activePartners,
                      icon: Icons.toggle_on_outlined,
                    ),
                    _MetricTile(
                      label: 'Inativos',
                      value: inactivePartners,
                      icon: Icons.toggle_off_outlined,
                    ),
                    const SizedBox(height: 16),
                    const _SectionTitle('Dicas de uso'),
                    const _Hint(
                      'Use o menu principal para navegar entre “Parceiros” e “Ocorrências”. '
                      'Os números acima atualizam automaticamente quando você cria/edita/exclui itens.',
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(
        value.toString(),
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final String text;
  const _Hint(this.text);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(text),
      subtitle: const Text('Tela reativa — powered by Hive listenable()'),
    );
  }
}
