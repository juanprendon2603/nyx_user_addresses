import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class LocationsAssetDataSource {
  Map<String, dynamic>? _cache;

  Future<void> _ensure() async {
    if (_cache != null) return;
    final raw = await rootBundle.loadString('assets/data/locations_co.json');
    _cache = json.decode(raw) as Map<String, dynamic>;
  }

  Future<List<String>> countries() async {
    await _ensure();
    return (_cache!.keys).toList()..sort();
  }

  Future<List<String>> departments(String country) async {
    await _ensure();
    final map = _cache![country] as Map<String, dynamic>? ?? {};
    return map.keys.toList()..sort();
  }

  Future<List<String>> municipalities(String country, String department) async {
    await _ensure();
    final dep = (_cache![country] as Map<String, dynamic>? ?? {})[department];
    final list = (dep as List?)?.cast<String>() ?? <String>[];
    list.sort();
    return list;
  }
}
