import 'package:flutter/material.dart';

abstract final class AppColors {
  static const seed = Color(0xFF0D7377);

  static final light = ColorScheme.fromSeed(seedColor: seed).copyWith(
    surface: const Color(0xFFF9FAFB),
    surfaceDim: const Color(0xFFE5E7EB),
    surfaceBright: const Color(0xFFFFFFFF),
    surfaceContainerLowest: const Color(0xFFFFFFFF),
    surfaceContainerLow: const Color(0xFFF9FAFB),
    surfaceContainer: const Color(0xFFF3F4F6),
    surfaceContainerHigh: const Color(0xFFECEEF1),
    surfaceContainerHighest: const Color(0xFFE5E7EB),
    outlineVariant: const Color(0xFFE5E7EB),
  );

  static final dark =
      ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark)
          .copyWith(
            surface: const Color(0xFF111827),
            surfaceDim: const Color(0xFF030712),
            surfaceBright: const Color(0xFF374151),
            surfaceContainerLowest: const Color(0xFF030712),
            surfaceContainerLow: const Color(0xFF111827),
            surfaceContainer: const Color(0xFF1F2937),
            surfaceContainerHigh: const Color(0xFF2A3441),
            surfaceContainerHighest: const Color(0xFF374151),
            outlineVariant: const Color(0xFF374151),
          );
}
