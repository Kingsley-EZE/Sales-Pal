import 'package:flutter/material.dart';

abstract final class AppColors {
  static const seed = Color(0xFF0D7377);

  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFED6C02);
  static const divider = Color(0xFFE5E7EB);
  static const iconBtnBg = Color(0xFFF3F4F6);

  static final light = ColorScheme.fromSeed(seedColor: seed);
  static final dark = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  );
}
