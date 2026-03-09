// lib/pages/connect_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // <-- necessário p/ Box.listenable
import '../data/models/partner_model.dart';

class ConnectPage extends StatefulWidget {
  final Box<PartnerModel> partnersBox;
  const ConnectPage({super.key, required this.partnersBox});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<PartnerModel> _filtered(Box<PartnerModel> box) {
    final q = _search.text.trim().toLowerCase();
    final base =
        box.values.where((p) => p.active).toList(); // só ativos + cópia
    if (q.isEmpty) {
      base.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return base;
    }
    return base
      ..retainWhere((p) {
        final hay = [
          p.name,
          p.org,
          ...p.tags,
        ].join(' ').toLowerCase();
        return hay.contains(q);
      })
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<void> _openSendSheet(BuildContext context, PartnerModel p) async {
    final channel = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('WhatsApp'),
              onTap: () => Navigator.pop(ctx, 'whatsapp'),
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('E-mail'),
              onTap: () => Navigator.pop(ctx, 'email'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || channel == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Canal escolhido: $channel para ${p.displayTitle}')),
    );

    // Aqui você pluga o launcher real (url_launcher/whatsApp/mailto).
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.partnersBox.listenable(),
      builder: (context, Box<PartnerModel> box, _) {
        final items = _filtered(box);

        return Scaffold(
          appBar: AppBar(title: const Text('Conectar com parceiro')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar por nome, org ou tag',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Mostra apenas ativos'))
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final p = items[i];
                          return ListTile(
                            leading: const Icon(Icons.handshake_outlined),
                            title: Text(p.name),
                            subtitle: Text(p.shortInfo),
                            onTap: () => _openSendSheet(context, p),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
