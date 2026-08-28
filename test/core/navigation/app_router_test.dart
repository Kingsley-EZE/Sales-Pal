import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/data/json_asset_loader.dart';
import 'package:sales_pal/core/di/injection.dart';
import 'package:sales_pal/features/customers/presentation/pages/customers_page.dart';
import 'package:sales_pal/features/orders/presentation/pages/orders_page.dart';
import 'package:sales_pal/features/products/presentation/pages/products_page.dart';
import 'package:sales_pal/main.dart';

void main() {
  // These tests build the real router, which resolves its cubits from the
  // container, so the graph has to exist. Reset between tests so no cubit
  // carries state across.
  setUp(() async {
    JsonAssetLoader.latency = Duration.zero;
    // rootBundle caches the Future, not the string. Left alone, a later test
    // awaits a Future created inside an earlier test's async zone and never
    // resumes, so the screen sits on its spinner forever.
    rootBundle.clear();
    await getIt.reset();
    await configureDependencies();
  });

  group('AppRouter', () {
    testWidgets('starts on the customers branch', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(CustomersPage), findsOneWidget);
    });

    testWidgets('switches branches from the bottom navigation', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductsPage), findsOneWidget);

      await tester.tap(find.text('Orders Queue'));
      await tester.pumpAndSettle();
      expect(find.byType(OrdersPage), findsOneWidget);
    });
  });
}
