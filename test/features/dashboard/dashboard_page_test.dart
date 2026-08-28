import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/data/json_asset_loader.dart';
import 'package:sales_pal/core/di/injection.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/main.dart';

void main() {
  setUp(() async {
    JsonAssetLoader.latency = Duration.zero;
    rootBundle.clear();
    await getIt.reset();
    await configureDependencies();
  });

  group('DashboardPage navigation bar', () {
    testWidgets('icons take their size from navigationBarTheme', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final icons = tester.widgetList<SvgPicture>(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.byType(SvgPicture),
        ),
      );
      expect(icons, isNotEmpty);
      for (final icon in icons) {
        expect(icon.width, AppIconSize.lg);
        expect(icon.height, AppIconSize.lg);
      }
    });

    testWidgets('labels are always shown', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      final context = tester.element(find.byType(NavigationBar));
      final behavior =
          navigationBar.labelBehavior ??
          NavigationBarTheme.of(context).labelBehavior;

      expect(behavior, NavigationDestinationLabelBehavior.alwaysShow);
    });
  });
}
