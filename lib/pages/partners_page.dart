import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/partner_model.dart';
import 'partners_form_page.dart';

class PartnersPage extends StatefulWidget {
  final Box<PartnerModel> partnersBox;

  const PartnersPage({
    super.key,
    required this.partnersBox,
  });

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // ===========================================================================
  // NOVO PARCEIRO
  // ===========================================================================
  Future<void> _newPartner() async {
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PartnersFormPage(
          partnersBox: widget.partnersBox,
        ),
      ),
    );
    if (ok == true && mounted) setState(() {});
  }

  // ===========================================================================
  // AUTENTICAÇÃO (ID + SENHA) PARA EDITAR / EXCLUIR
  // ===========================================================================
  Future<bool> _ensureAuth(PartnerModel partner) async {
    // se ainda não tem login/senha (dados antigos), libera sem pedir
    if (partner.loginId.isEmpty || partner.password.isEmpty) {
      return true;
    }

    final idController = TextEditingController();
    final passController = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Autenticar parceiro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'ID de acesso',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final okId = idController.text.trim() == partner.loginId;
                final okPass = passController.text.trim() == partner.password;
                Navigator.of(ctx).pop(okId && okPass);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (ok != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID ou senha inválidos')),
        );
      }
      return false;
    }

    return true;
  }

  // ===========================================================================
  // EDITAR / ATIVAR / DESATIVAR / EXCLUIR
  // ===========================================================================
  Future<void> _edit(PartnerModel partner) async {
    if (!await _ensureAuth(partner)) return;

    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PartnersFormPage(
          partnersBox: widget.partnersBox,
          partner: partner,
        ),
      ),
    );
    if (ok == true && mounted) setState(() {});
  }

  Future<void> _toggleActive(PartnerModel partner) async {
    final updated = partner.copyWith(active: !partner.active);
    await widget.partnersBox.put(updated.id, updated);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(updated.active ? 'Parceiro ativado' : 'Parceiro desativado'),
      ),
    );
  }

  Future<void> _delete(PartnerModel partner) async {
    if (!await _ensureAuth(partner)) return;
    await widget.partnersBox.delete(partner.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Parceiro excluído')),
    );
  }

  // ===========================================================================
  // FILTRO
  // ===========================================================================
  List<PartnerModel> _filtered(List<PartnerModel> all) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return all;

    return all.where((p) {
      final haystack = '${p.name} ${p.org} ${p.tags.join(' ')}'.toLowerCase();
      return haystack.contains(q);
    }).toList(growable: false);
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parceiros'),
        actions: [
          IconButton(
            tooltip: 'Novo parceiro',
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: _newPartner,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.partnersBox.listenable(),
        builder: (context, Box<PartnerModel> box, _) {
          final items = _filtered(box.values.toList())
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(
                    b.name.toLowerCase(),
                  ),
            );

          if (items.isEmpty) {
            return const Center(
              child: Text('Nenhum parceiro cadastrado.'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _search,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar por nome, organização ou tag',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final p = items[i];

                    final subtitleParts = <String>[];
                    if (p.org.isNotEmpty) subtitleParts.add(p.org);
                    if (p.tags.isNotEmpty) {
                      subtitleParts.add(p.tags.join(' • '));
                    }
                    final subtitle = subtitleParts.join(' • ');

                    return ListTile(
                      leading: Icon(
                        Icons.groups,
                        color: p.active ? Colors.green : Colors.grey,
                      ),
                      title: Text(p.name),
                      subtitle: subtitle.isEmpty
                          ? null
                          : Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      onTap: () => _edit(p),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'toggle') {
                            await _toggleActive(p);
                          } else if (value == 'edit') {
                            await _edit(p);
                          } else if (value == 'delete') {
                            await _delete(p);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'toggle',
                            child: Text(
                              p.active ? 'Desativar' : 'Ativar',
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Excluir'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newPartner,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Novo parceiro'),
      ),
    );
  }
}
