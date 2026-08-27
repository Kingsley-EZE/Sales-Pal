import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/design/semantic_colors.dart';
import 'package:sales_pal/design/theme.dart';

void main() {
  Future<AppSemanticColors> resolve(WidgetTester tester, ThemeData theme) async {
    late AppSemanticColors resolved;
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Builder(
          builder: (context) {
            resolved = AppSemanticColors.of(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return resolved;
  }

  group('AppSemanticColors', () {
    testWidgets('resolves per brightness', (tester) async {
      expect(await resolve(tester, AppTheme.light), AppSemanticColors.light);
      expect(await resolve(tester, AppTheme.dark), AppSemanticColors.dark);
    });

    testWidgets('falls back to light when not registered', (tester) async {
      expect(await resolve(tester, ThemeData.light()), AppSemanticColors.light);
    });

    test('lerp interpolates between variants', () {
      final midpoint = AppSemanticColors.light.lerp(
        AppSemanticColors.dark,
        0.5,
      );

      expect(midpoint.success, isNot(AppSemanticColors.light.success));
      expect(midpoint.success, isNot(AppSemanticColors.dark.success));
    });
  });

  group('divider colour', () {
    test('differs between light and dark schemes', () {
      expect(
        AppTheme.light.dividerTheme.color,
        isNot(AppTheme.dark.dividerTheme.color),
      );
      expect(
        AppTheme.dark.dividerTheme.color,
        AppTheme.dark.colorScheme.outlineVariant,
      );
    });
  });
}