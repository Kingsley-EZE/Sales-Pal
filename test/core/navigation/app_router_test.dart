import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/features/customers/presentation/pages/customers_page.dart';
import 'package:sales_pal/features/orders/presentation/pages/orders_page.dart';
import 'package:sales_pal/features/products/presentation/pages/products_page.dart';
import 'package:sales_pal/main.dart';

import '../../support/dependencies.dart';
import '../../support/pumping.dart';

void main() {
  useTestDependencies();

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
      await settleThroughDatabase(tester);
      expect(find.byType(OrdersPage), findsOneWidget);
    });
  });
}
