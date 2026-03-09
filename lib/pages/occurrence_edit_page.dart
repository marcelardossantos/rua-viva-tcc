import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/occurrence_model.dart';
import 'map_picker_page.dart';

class OccurrenceEditPage extends StatefulWidget {
  final Box<OccurrenceModel> box;
  final OccurrenceModel occurrence;

  const OccurrenceEditPage({
    super.key,
    required this.box,
    required this.occurrence,
  });

  @override
  State<OccurrenceEditPage> createState() => _OccurrenceEditPageState();
}

class _OccurrenceEditPageState extends State<OccurrenceEditPage> {
  final _form = GlobalKey<FormState>();

  late String _type;
  late TextEditingController _notes;

  late double _lat;
  late double _lon;

  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final o = widget.occurrence;
    _type = o.type;
    _notes = TextEditingController(text: o.notes ?? '');
    _lat = o.lat;
    _lon = o.lon;
    _imagePath = o.imagePath;
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.of(context).push<MapPickerResult>(
      MaterialPageRoute(
        builder: (_) => MapPickerPage(
          initialLat: _lat,
          initialLon: _lon,
        ),
      ),
    );

    if (result == null) return;

    setState(() {
      _lat = result.lat;
      _lon = result.lon;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;

    try {
      final original = widget.occurrence;

      final updated = OccurrenceModel(
        id: original.id,
        type: _type.toLowerCase(),
        dateTime: DateTime.now(),
        lat: _lat,
        lon: _lon,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        imagePath: _imagePath,
        pendingSync: true,
      );

      await widget.box.put(original.id, updated);

      if (!mounted) return;
      Navigator.of(context).pop(updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar ocorrência: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar ocorrência'),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Tipo'),
              items: const [
                DropdownMenuItem(value: 'Pessoa', child: Text('Pessoa')),
                DropdownMenuItem(value: 'Família', child: Text('Família')),
                DropdownMenuItem(value: 'Grupo', child: Text('Grupo')),
                DropdownMenuItem(value: 'Outro', child: Text('Outro')),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _type = v);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Observações',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(
                  'Localização (${_lat.toStringAsFixed(5)}, ${_lon.toStringAsFixed(5)})'),
              trailing: IconButton(
                icon: const Icon(Icons.edit_location_alt),
                onPressed: _openMapPicker,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
