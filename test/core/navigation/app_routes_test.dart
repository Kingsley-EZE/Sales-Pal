import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_pal/core/data/json_asset_loader.dart';
import 'package:sales_pal/core/di/injection.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/theme.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
import 'package:sales_pal/features/customers/presentation/pages/customer_details_page.dart';
import 'package:sales_pal/features/orders/presentation/pages/new_order_page.dart';
import 'package:sales_pal/features/orders/presentation/pages/review_order_page.dart';

const _customer = Customer(
  id: '3',
  name: 'Acme Groceries Ltd.',
  location: 'Downtown Outlet',
  phoneNumber: '(555) 019-2831',
  amountDue: 1240,
);

/// A router per test. [AppRouter.router] is a singleton, so sharing it would
/// carry one test's navigation stack into the next.
GoRouter _router() => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: const CustomersRoute().location,
  routes: $appRoutes,
);

Future<GoRouter> _pumpAtCustomerDetails(WidgetTester tester) async {
  final router = _router();
  await tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light, routerConfig: router),
  );
  await tester.pumpAndSettle();

  router.push(
    const CustomerDetailsRoute(customerId: '3', $extra: _customer).location,
    extra: _customer,
  );
  await tester.pumpAndSettle();

  return router;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  // The router resolves its cubits from the container. Reset between tests so
  // no cubit carries state across.
  setUp(() async {
    JsonAssetLoader.latency = Duration.zero;
    // rootBundle caches the Future, not the string. Left alone, a later test
    // awaits a Future created inside an earlier test's async zone and never
    // resumes, so the screen sits on its spinner forever.
    rootBundle.clear();
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('customer details pushes the new order page', (tester) async {
    final router = await _pumpAtCustomerDetails(tester);
    expect(find.byType(CustomerDetailsPage), findsOneWidget);

    // Nesting under the details route means this push rebuilds that route too,
    // so the extra has to travel with it.
    router.push(
      const NewOrderRoute(customerId: '3', $extra: _customer).location,
      extra: _customer,
    );
    await tester.pumpAndSettle();

    expect(find.byType(NewOrderPage), findsOneWidget);
    expect(find.text('Acme Groceries Ltd.'), findsOneWidget);
  });

  testWidgets('new order pushes the review order page', (tester) async {
    final router = await _pumpAtCustomerDetails(tester);

    router.push(
      const NewOrderRoute(customerId: '3', $extra: _customer).location,
      extra: _customer,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Review Order'));
    await tester.pumpAndSettle();

    expect(find.byType(ReviewOrderPage), findsOneWidget);
    expect(find.text('Order Total'), findsOneWidget);
    expect(find.text('₦80.65'), findsOneWidget);
  });

  testWidgets('review order pops back to the new order page', (tester) async {
    final router = await _pumpAtCustomerDetails(tester);

    router.push(
      const NewOrderRoute(customerId: '3', $extra: _customer).location,
      extra: _customer,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review Order'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit Order'));
    await tester.pumpAndSettle();

    expect(find.byType(NewOrderPage), findsOneWidget);
    expect(find.byType(ReviewOrderPage), findsNothing);
  });
}
