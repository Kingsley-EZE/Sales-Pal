import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/design/components/app_button.dart';
import 'package:sales_pal/design/radius.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/theme.dart';

void main() {
  Future<void> pumpButton(WidgetTester tester, AppButtonType type) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AppButton(label: 'Click Me', onPressed: () {}, type: type),
        ),
      ),
    );
  }

  group('AppButton', () {
    testWidgets('label inherits the button text style from the theme', (
      tester,
    ) async {
      await pumpButton(tester, AppButtonType.primary);

      final style = DefaultTextStyle.of(
        tester.element(find.text('Click Me')),
      ).style;

      expect(style.fontWeight, FontWeight.w700);
      expect(style.fontSize, 16);
    });

    testWidgets('shape radius comes from the theme, not the widget', (
      tester,
    ) async {
      await pumpButton(tester, AppButtonType.primary);

      final button = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );
      expect(button.style!.shape, isNull);

      final themeShape = Theme.of(tester.element(find.byType(OutlinedButton)))
          .outlinedButtonTheme
          .style!
          .shape!
          .resolve({});
      expect(
        (themeShape! as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(AppRadius.md),
      );
    });

    testWidgets('is one tap target tall', (tester) async {
      await pumpButton(tester, AppButtonType.primary);

      expect(
        tester.getSize(find.byType(OutlinedButton)).height,
        AppSize.tapTarget,
      );
    });

    testWidgets('secondary type draws an outline, primary does not', (
      tester,
    ) async {
      await pumpButton(tester, AppButtonType.secondary);
      final secondary = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );
      expect(secondary.style!.side?.resolve({}), isNot(BorderSide.none));

      await pumpButton(tester, AppButtonType.primary);
      final primary = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );
      expect(primary.style!.side?.resolve({}), BorderSide.none);
    });
  });
}
