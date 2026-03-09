// lib/utils/export.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../data/models/occurrence.dart';

// Para Flutter Web (download no navegador).
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html show AnchorElement, Blob, Url;

String _csvFor(List<OccurrenceModel> items) {
  const sep = ',';
  final sb = StringBuffer()
    ..writeln(
      [
        'id',
        'lat',
        'lon',
        'datetime_iso',
        'type',
        'notes',
        'pendingSync',
        'imagePath',
      ].join(sep),
    );

  String esc(String v) {
    final s = v.replaceAll('"', '""').replaceAll('\n', ' ');
    return '"$s"';
  }

  for (final o in items) {
    sb.writeln(
      [
        esc(o.id),
        o.lat.toStringAsFixed(6),
        o.lon.toStringAsFixed(6),
        o.dateTime.toIso8601String(),
        esc(o.type),
        esc(o.notes),
        o.pendingSync ? '1' : '0',
        esc(o.imagePath ?? ''),
      ].join(sep),
    );
  }
  return sb.toString();
}

Map<String, dynamic> _geoJsonFor(List<OccurrenceModel> items) {
  return {
    'type': 'FeatureCollection',
    'features': items.map((o) {
      return {
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          // GeoJSON usa [lon, lat]
          'coordinates': [o.lon, o.lat],
        },
        'properties': {
          'id': o.id,
          'datetime': o.dateTime.toIso8601String(),
          'type': o.type,
          'notes': o.notes,
          'pendingSync': o.pendingSync,
          if (o.imagePath != null) 'imagePath': o.imagePath,
        },
      };
    }).toList(),
  };
}

void _downloadWeb(String filename, String mime, List<int> bytes) {
  final blob = html.Blob([bytes], mime);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final a = html.AnchorElement(href: url)..download = filename;
  a.click();
  html.Url.revokeObjectUrl(url);
}

Future<void> exportCsv(List<OccurrenceModel> items) async {
  if (kIsWeb) {
    final csv = _csvFor(items);
    _downloadWeb('ocorrencias.csv', 'text/csv;charset=utf-8', utf8.encode(csv));
    return;
  }
  throw UnsupportedError('Exportar CSV: implemente caminho mobile depois.');
}

Future<void> exportGeoJson(List<OccurrenceModel> items) async {
  if (kIsWeb) {
    final geo = _geoJsonFor(items);
    final jsonStr = const JsonEncoder.withIndent('  ').convert(geo);
    _downloadWeb(
      'ocorrencias.geojson',
      'application/geo+json',
      utf8.encode(jsonStr),
    );
    return;
  }
  throw UnsupportedError('Exportar GeoJSON: implemente caminho mobile depois.');
}
