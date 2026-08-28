import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class JsonAssetLoader {
  const JsonAssetLoader();

  static Duration latency = const Duration(milliseconds: 600);

  Future<List<Map<String, dynamic>>> loadList(String assetPath) async {
    await Future<void>.delayed(latency);

    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;

    return decoded.cast<Map<String, dynamic>>();
  }
}
