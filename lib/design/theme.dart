import 'package:flutter/material.dart';

import 'colors.dart';
import 'radius.dart';
import 'sizes.dart';
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: AppTypography.buttonLabel,
          minimumSize: const Size(64, AppSize.tapTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          elevation: 0,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 0,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: AppIconSize.lg,
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSecondaryContainer
                : colorScheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppTypography.navigationLabel.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                )
              : AppTypography.navigationLabel.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: AppSize.dividerThickness,
        space: AppSize.dividerThickness,
      ),
      cardTheme: CardThemeData(
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
