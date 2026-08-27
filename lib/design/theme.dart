import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _themeFrom(AppColors.light);
  static ThemeData get dark => _themeFrom(AppColors.dark);

  static ThemeData _themeFrom(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
