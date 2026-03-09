import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/occurrence_model.dart';
import '../data/models/partner_model.dart';
import 'new_occurrence_page.dart';

class OccurrencesPage extends StatefulWidget {
  final Box<OccurrenceModel> occBox;
  final Box<PartnerModel> partnersBox;

  const OccurrencesPage({
    super.key,
    required this.occBox,
    required this.partnersBox,
  });

  @override
  State<OccurrencesPage> createState() => _OccurrencesPageState();
}

class _OccurrencesPageState extends State<OccurrencesPage> {
  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  /// Texto que será compartilhado (inclui mapa, contato do parceiro
  /// e observações). Também finaliza com "Enviado pelo app Rua Viva."
  String _buildShareText(OccurrenceModel occ, PartnerModel partner) {
    final lat = occ.lat;
    final lon = occ.lon;

    // Link do Google Maps (usado para o preview do mapa no WhatsApp)
    final mapsUrl = 'https://www.google.com/maps?q=$lat,$lon';

    final buffer = StringBuffer()
      // Primeiro o link do mapa, para gerar o preview no WhatsApp
      ..writeln(mapsUrl)
      ..writeln()
      ..writeln('Olá ${partner.name},')
      ..writeln()
      ..writeln(
        'Há uma nova ocorrência do tipo "Pessoa em situação de rua" '
        'registrada no aplicativo Rua Viva.',
      )
      ..writeln('Data/hora: ${_formatDate(occ.dateTime)}')
      ..writeln(
        'Localização aproximada: (${lat.toStringAsFixed(5)}, '
        '${lon.toStringAsFixed(5)})',
      )
      ..writeln()
      ..writeln('Parceiro responsável: ${partner.name}')
      ..writeln('Organização: ${partner.org}')
      ..writeln('Contato:');

    if (partner.phone.isNotEmpty) {
      buffer.writeln('- Telefone: ${partner.phone}');
    }
    if (partner.email.isNotEmpty) {
      buffer.writeln('- E-mail: ${partner.email}');
    }

    if (occ.notes != null && occ.notes!.trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Observações:')
        ..writeln(occ.notes!.trim());
    }

    buffer
      ..writeln()
      ..writeln('Ver no mapa: $mapsUrl')
      ..writeln()
      ..writeln('Enviado pelo app Rua Viva.');

    return buffer.toString();
  }

  Future<PartnerModel?> _pickPartner() async {
    final partners = widget.partnersBox.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    if (partners.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhum parceiro cadastrado para compartilhar.'),
          ),
        );
      }
      return null;
    }

    return showModalBottomSheet<PartnerModel>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Escolha o parceiro',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 0),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: partners.length,
                  itemBuilder: (context, index) {
                    final p = partners[index];
                    return ListTile(
                      leading: const Icon(Icons.groups),
                      title: Text(p.name),
                      subtitle: Text(p.org),
                      onTap: () => Navigator.of(ctx).pop(p),
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

  Future<String?> _pickChannel() {
    return showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Como deseja compartilhar?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('WhatsApp'),
                onTap: () => Navigator.of(ctx).pop('whatsapp'),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('E-mail'),
                onTap: () => Navigator.of(ctx).pop('email'),
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copiar texto'),
                onTap: () => Navigator.of(ctx).pop('copy'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _shareOccurrence(
    OccurrenceModel occ,
    PartnerModel partner,
    String channel,
  ) async {
    final text = _buildShareText(occ, partner);

    if (channel == 'whatsapp') {
      if (partner.phone.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Parceiro sem telefone cadastrado.'),
            ),
          );
        }
        return;
      }

      final digits = partner.phone.replaceAll(RegExp(r'\D'), '');
      if (digits.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Telefone do parceiro inválido.'),
            ),
          );
        }
        return;
      }

      final uri = Uri.parse(
        'https://wa.me/55$digits?text=${Uri.encodeComponent(text)}',
      );

      try {
        final ok = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );

        if (!ok && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o WhatsApp.'),
            ),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o WhatsApp.'),
            ),
          );
        }
      }
    } else if (channel == 'email') {
      if (partner.email.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Parceiro sem e-mail cadastrado.'),
            ),
          );
        }
        return;
      }

      final uri = Uri(
        scheme: 'mailto',
        path: partner.email,
        queryParameters: {
          'subject': 'Ocorrência Rua Viva',
          'body': text,
        },
      );

      try {
        final ok = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        if (!ok && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o aplicativo de e-mail.'),
            ),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o aplicativo de e-mail.'),
            ),
          );
        }
      }
    } else if (channel == 'copy') {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Texto copiado para a área de transferência.'),
          ),
        );
      }
    }
  }

  Future<void> _choosePartnerAndChannelAndShare(OccurrenceModel occ) async {
    final partner = await _pickPartner();
    if (partner == null) return;

    final channel = await _pickChannel();
    if (channel == null) return;

    await _shareOccurrence(occ, partner, channel);
  }

  @override
  Widget build(BuildContext context) {
    final occurrences = widget.occBox.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocorrências'),
      ),
      body: occurrences.isEmpty
          ? const Center(
              child: Text('Nenhuma ocorrência cadastrada ainda.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: occurrences.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final occ = occurrences[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(
                      'Pessoa em situação de rua • ${_formatDate(occ.dateTime)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '(${occ.lat.toStringAsFixed(5)}, '
                      '${occ.lon.toStringAsFixed(5)})',
                    ),
                    onTap: () => _choosePartnerAndChannelAndShare(occ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Excluir ocorrência'),
                            content: const Text(
                              'Tem certeza que deseja excluir esta ocorrência?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await widget.occBox.delete(occ.id);
                          if (mounted) {
                            setState(() {});
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => NewOccurrencePage(box: widget.occBox),
            ),
          );

          if (created == true) {
            if (!mounted) return;

            setState(() {});

            final all = widget.occBox.values.toList()
              ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
            final createdOcc = all.first;

            await _choosePartnerAndChannelAndShare(createdOcc);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova e compartilhar'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
