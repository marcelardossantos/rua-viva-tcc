import 'package:hive/hive.dart';

import '../models/partner_model.dart';

/// Popula a box de parceiros com alguns exemplos iniciais.
/// Só roda se a box estiver vazia.
Future<void> seedPartners(Box<PartnerModel> box) async {
  if (box.isNotEmpty) return;

  await _insertDefaultPartners(box);
}

Future<void> _insertDefaultPartners(Box<PartnerModel> box) async {
  await box.put(
    'p001',
    const PartnerModel(
      id: 'p001',
      name: 'Casa Solidária',
      org: 'ONG Esperança Viva',
      email: 'contato@esperancaviva.org',
      phone: '27981219912',
      lat: -20.3686,
      lon: -40.2981,
      tags: ['alimentação', 'acolhimento'],
      active: true,
      loginId: 'p001',
      password: '1234',
    ),
  );

  await box.put(
    'p002',
    const PartnerModel(
      id: 'p002',
      name: 'Rede Abrigo da Rua',
      org: 'Projeto Abrace',
      email: 'contato@abrace.org',
      phone: '27997222222',
      lat: -20.3190,
      lon: -40.3380,
      tags: ['abrigo', 'pernoite'],
      active: true,
      loginId: 'p002',
      password: '1234',
    ),
  );

  await box.put(
    'p003',
    const PartnerModel(
      id: 'p003',
      name: 'Consultório na Rua',
      org: 'Equipe Saúde Cidadã',
      email: 'saude@ruaviva.org',
      phone: '27997333333',
      lat: -20.3120,
      lon: -40.2920,
      tags: ['saúde', 'orientação'],
      active: true,
      loginId: 'p003',
      password: '1234',
    ),
  );
}
