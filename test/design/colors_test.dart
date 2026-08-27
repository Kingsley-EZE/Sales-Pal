import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/design/colors.dart';
import 'package:sales_pal/design/theme.dart';

void main() {
  group('AppColors', () {
    test('light surface matches the design spec', () {
      expect(AppColors.light.surface, const Color(0xFFF9FAFB));
    });

    test('scaffold background follows surface', () {
      expect(
        AppTheme.light.scaffoldBackgroundColor,
        AppColors.light.surface,
      );
    });

    test('surface family is neutral, not seed tinted', () {
      for (final color in [
        AppColors.light.surface,
        AppColors.light.surfaceContainer,
        AppColors.light.surfaceContainerHighest,
      ]) {
        expect(
          color.g,
          lessThanOrEqualTo(color.b),
          reason: 'a teal tint would push green above blue',
        );
      }
    });

    test('container ramp darkens monotonically in light mode', () {
      final ramp = [
        AppColors.light.surfaceContainerLowest,
        AppColors.light.surfaceContainerLow,
        AppColors.light.surfaceContainer,
        AppColors.light.surfaceContainerHigh,
        AppColors.light.surfaceContainerHighest,
      ];

      for (var i = 1; i < ramp.length; i++) {
        expect(
          ramp[i].computeLuminance(),
          lessThanOrEqualTo(ramp[i - 1].computeLuminance()),
        );
      }
    });
  });
}
