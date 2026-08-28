import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/data/json_asset_loader.dart';
import 'package:sales_pal/core/di/injection.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/main.dart';

void main() {
  // MyApp builds the real router, whose routes resolve cubits from the
  // container.
  setUp(() async {
    JsonAssetLoader.latency = Duration.zero;
    // rootBundle caches the Future, not the string. Left alone, a later test
    // awaits a Future created inside an earlier test's async zone and never
    // resumes, so the screen sits on its spinner forever.
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
