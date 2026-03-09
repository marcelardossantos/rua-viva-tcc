import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/models/occurrence_model.dart';
import '../themes/app_colors.dart';
import 'map_picker_page.dart';

class NewOccurrencePage extends StatefulWidget {
  final Box<OccurrenceModel> box;

  const NewOccurrencePage({
    super.key,
    required this.box,
  });

  @override
  State<NewOccurrencePage> createState() => _NewOccurrencePageState();
}

class _NewOccurrencePageState extends State<NewOccurrencePage> {
  final TextEditingController _notes = TextEditingController();

  String? _selectedAge;
  String? _selectedGender;
  final Set<String> _specificCircumstances = {};
  final Set<String> _sentiments = {};

  double _lat = -20.36859;
  double _lon = -40.29809;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // MAPA – ESCOLHER LOCALIZAÇÃO
  // ---------------------------------------------------------------------------
  Future<void> _openMapPicker() async {
    final result = await Navigator.of(context).push<MapPickerResult>(
      MaterialPageRoute(
        builder: (_) => MapPickerPage(
          initialLat: _lat,
          initialLon: _lon,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _lat = result.lat;
      _lon = result.lon;
    });
  }

  // ---------------------------------------------------------------------------
  // SALVAR OCORRÊNCIA
  // ---------------------------------------------------------------------------
  Future<void> _save() async {
    try {
      final occ = OccurrenceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'Pessoa em situação de rua',
        dateTime: DateTime.now(),
        lat: _lat,
        lon: _lon,
        notes: _buildNotesText(),
        imagePath: null,
        pendingSync: true,
        // partnerId / partnerName serão preenchidos depois no compartilhamento
      );

      // 🔹 Importante: salvamos como NOVO REGISTRO na box (índice novo)
      await widget.box.add(occ);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocorrência salva com sucesso!')),
      );

      // evita o erro de navegação travada (_debugLocked)
      Future.microtask(() {
        if (mounted) Navigator.of(context).pop(true); // indica sucesso
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar ocorrência: $e')),
      );
    }
  }

  String _buildNotesText() {
    final buffer = StringBuffer();

    if (_selectedAge != null) buffer.writeln('Faixa etária: $_selectedAge');
    if (_selectedGender != null) buffer.writeln('Gênero: $_selectedGender');

    if (_specificCircumstances.isNotEmpty) {
      buffer.writeln('Circunstâncias específicas:');
      buffer.writeln(_specificCircumstances.join(', '));
    }

    if (_sentiments.isNotEmpty) {
      buffer.writeln('Sentimentos observados:');
      buffer.writeln(_sentiments.join(', '));
    }

    if (_notes.text.trim().isNotEmpty) {
      buffer.writeln('Observações adicionais:');
      buffer.writeln(_notes.text.trim());
    }

    return buffer.toString().trim();
  }

  // ---------------------------------------------------------------------------
  // UI DE CHIPS
  // ---------------------------------------------------------------------------
  Widget _buildChoiceSection({
    required String title,
    required List<String> options,
    required dynamic currentValue,
    required Function(String) onSelected,
    bool multiSelect = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((opt) {
            final bool isSelected =
                multiSelect ? currentValue.contains(opt) : currentValue == opt;

            return FilterChip(
              selected: isSelected,
              label: Text(opt),
              onSelected: (selected) {
                setState(() {
                  if (multiSelect) {
                    if (selected) {
                      currentValue.add(opt);
                    } else {
                      currentValue.remove(opt);
                    }
                  } else {
                    onSelected(opt);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova ocorrência'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChoiceSection(
              title: 'Faixa etária',
              options: ['Jovem', 'Adulto', 'Idoso'],
              currentValue: _selectedAge,
              onSelected: (v) => _selectedAge = v,
            ),
            _buildChoiceSection(
              title: 'Gênero',
              options: ['Homem', 'Mulher', 'Famílias'],
              currentValue: _selectedGender,
              onSelected: (v) => _selectedGender = v,
            ),
            _buildChoiceSection(
              title: 'Circunstâncias específicas',
              options: [
                'Pessoa com deficiência',
                'Problemas de saúde mental',
                'Vício em drogas/álcool',
                'Expulsa de casa',
                'Perderam vínculos familiares',
                'Dificuldades de reintegração social',
                'LGBTQIAPN+',
                'Sofre discriminação',
                'Sofre violência',
              ],
              currentValue: _specificCircumstances,
              onSelected: (_) {},
              multiSelect: true,
            ),
            _buildChoiceSection(
              title: 'Manifestação de sentimentos',
              options: ['Raiva', 'Tristeza', 'Revolta', 'Dor', 'Fome'],
              currentValue: _sentiments,
              onSelected: (_) {},
              multiSelect: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notes,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Observações adicionais (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 8),
                Text(
                  'Localização atual\n(${_lat.toStringAsFixed(5)}, ${_lon.toStringAsFixed(5)})',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openMapPicker,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Escolher localização no mapa'),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onPressed: _save,
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
