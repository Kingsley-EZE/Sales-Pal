import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_pal/core/navigation/app_router.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/theme.dart';
import 'package:sales_pal/features/customers/domain/customer.dart';
import 'package:sales_pal/features/customers/presentation/pages/customer_details_page.dart';
import 'package:sales_pal/features/orders/presentation/pages/new_order_page.dart';

const _customer = Customer(
  id: '3',
  name: 'Acme Groceries Ltd.',
  location: 'Downtown Outlet',
  phoneNumber: '(555) 019-2831',
  amountDue: 1240,
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('customer details pushes the new order page', (tester) async {
    final router = AppRouter.router;
    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
    await tester.pumpAndSettle();

    router.push(
      const CustomerDetailsRoute(customerId: '3', $extra: _customer).location,
      extra: _customer,
    );
    await tester.pumpAndSettle();
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
}
