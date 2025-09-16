import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class LocationsAssetDataSource {
  List<Map<String, dynamic>>? _cache;

  Future<void> _ensure() async {
    if (_cache != null) return;
    final raw = await rootBundle.loadString('assets/data/locations_co.json');
    final decoded = json.decode(raw);
    if (decoded is! List) {
      throw StateError(
        'Formato no soportado: se esperaba una lista de departamentos/ciudades.',
      );
    }
    _cache = decoded.cast<Map<String, dynamic>>();
  }

  Future<List<String>> countries() async {
    await _ensure();
    return const ['Colombia'];
  }

  Future<List<String>> departments(String country) async {
    await _ensure();
    final set = _cache!
        .map((e) => (e['departamento'] as String?)?.trim())
        .whereType<String>()
        .toSet();
    final list = set.toList()..sort();
    return list;
  }

  Future<List<String>> municipalities(String country, String department) async {
    await _ensure();
    final match = _cache!.firstWhere(
      (e) => (e['departamento'] as String?)?.trim() == department.trim(),
      orElse: () => const <String, dynamic>{},
    );
    final cities =
        (match['ciudades'] as List?)?.map((e) => e.toString()).toList() ??
            <String>[];
    cities.sort();
    return cities;
  }
}
