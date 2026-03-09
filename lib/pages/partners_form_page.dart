import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/partner_model.dart';

class PartnersFormPage extends StatefulWidget {
  final Box<PartnerModel> partnersBox;
  final PartnerModel? partner; // null => novo parceiro

  const PartnersFormPage({
    super.key,
    required this.partnersBox,
    this.partner,
  });

  @override
  State<PartnersFormPage> createState() => _PartnersFormPageState();
}

class _PartnersFormPageState extends State<PartnersFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _org = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _tags = TextEditingController();
  final _loginId = TextEditingController();
  final _password = TextEditingController();

  bool _active = true;

  @override
  void initState() {
    super.initState();
    final p = widget.partner;
    if (p != null) {
      _name.text = p.name;
      _org.text = p.org;
      _email.text = p.email;
      _phone.text = p.phone;
      _tags.text = p.tags.join(', ');
      _loginId.text = p.loginId;
      _password.text = p.password;
      _active = p.active;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _org.dispose();
    _email.dispose();
    _phone.dispose();
    _tags.dispose();
    _loginId.dispose();
    _password.dispose();
    super.dispose();
  }

  List<String> _parseTags(String raw) => raw
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList(growable: false);

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final existing = widget.partner;

    final partner = PartnerModel(
      id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      org: _org.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      tags: _parseTags(_tags.text),
      lat: existing?.lat ?? 0,
      lon: existing?.lon ?? 0,
      active: _active,
      loginId: _loginId.text.trim(),
      password: _password.text.trim(),
    );

    await widget.partnersBox.put(partner.id, partner);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Parceiro salvo com sucesso!')),
    );
    Navigator.of(context).pop(true); // indica sucesso pra tela anterior
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.partner != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar parceiro' : 'Novo parceiro'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Nome do parceiro',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _org,
              decoration: const InputDecoration(
                labelText: 'Organização (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _loginId,
              decoration: const InputDecoration(
                labelText: 'ID de acesso do parceiro',
                helperText: 'Ex.: ruaviva_p1 (usado para login)',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Informe o ID de acesso';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Informe a senha';
                }
                if (v.trim().length < 4) {
                  return 'Use pelo menos 4 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tags,
              decoration: const InputDecoration(
                labelText: 'Tags (separe por vírgula)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _active,
              title: const Text('Ativo'),
              subtitle: const Text('Se desativado, não aparecerá em listagens'),
              onChanged: (v) => setState(() => _active = v),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
