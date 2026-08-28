import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_pal/core/connectivity/connectivity_cubit.dart';
import 'package:sales_pal/core/di/injection.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/theme.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
import 'package:sales_pal/features/customers/presentation/pages/customer_details_page.dart';
import 'package:sales_pal/features/customers/presentation/pages/select_customer_page.dart';
import 'package:sales_pal/features/customers/presentation/widgets/customer_list_item.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';
import 'package:sales_pal/features/orders/presentation/pages/new_order_page.dart';
import 'package:sales_pal/features/orders/presentation/pages/review_order_page.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/orders/domain/repositories/order_repository.dart';
import 'package:sales_pal/features/orders/presentation/cubit/submit_order_cubit.dart';
import 'package:sales_pal/features/orders/presentation/pages/orders_page.dart';
import 'package:sales_pal/features/products/domain/entities/product.dart';

import '../../support/dependencies.dart';
import '../../support/pumping.dart';

const _customer = Customer(
  id: '3',
  name: 'Acme Groceries Ltd.',
  location: 'Downtown Outlet',
  phoneNumber: '(555) 019-2831',
  amountDue: 1240,
);

const _coffee = Product(
  id: 'PRD-001',
  name: 'Organic Premium Roast Coffee (1kg)',
  imagePath: 'assets/images/img_product_sample.png',
  stockUnits: 112,
  price: 24.50,
);

const _oil = Product(
  id: 'PRD-002',
  name: 'Extra Virgin Olive Oil (750ml)',
  imagePath: 'assets/images/img_product_sample.png',
  stockUnits: 45,
  price: 18.90,
);

/// A router per test. [AppRouter.router] is a singleton, so sharing it would
/// carry one test's navigation stack into the next.
GoRouter _router() => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: const CustomersRoute().location,
  routes: $appRoutes,
);

Future<GoRouter> _pump(WidgetTester tester) async {
  final router = _router();
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<OrderDraftCubit>()),
        BlocProvider.value(value: getIt<SubmitOrderCubit>()),
        BlocProvider.value(value: getIt<ConnectivityCubit>()),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();

  return router;
}

Future<GoRouter> _pumpAtCustomerDetails(WidgetTester tester) async {
  final router = await _pump(tester);

  router.push(
    const CustomerDetailsRoute(customerId: '3', $extra: _customer).location,
    extra: _customer,
  );
  await tester.pumpAndSettle();

  return router;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  useTestDependencies();

  testWidgets('create order opens the cart for that customer', (tester) async {
    await _pumpAtCustomerDetails(tester);
    expect(find.byType(CustomerDetailsPage), findsOneWidget);

    await tester.tap(find.text('Create Order'));
    await tester.pumpAndSettle();

    expect(find.byType(NewOrderPage), findsOneWidget);
    expect(find.text('Acme Groceries Ltd.'), findsOneWidget);
    expect(getIt<OrderDraftCubit>().state.customer, _customer);
  });

  testWidgets('an empty cart cannot be reviewed', (tester) async {
    await _pumpAtCustomerDetails(tester);
    await tester.tap(find.text('Create Order'));
    await tester.pumpAndSettle();

    final reviewButton = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('Review Order'),
        matching: find.byType(OutlinedButton),
      ),
    );

    expect(reviewButton.onPressed, isNull);
  });

  testWidgets('new order pushes the review order page', (tester) async {
    getIt<OrderDraftCubit>()
      ..addProduct(_coffee)
      ..addProduct(_oil);

    await _pumpAtCustomerDetails(tester);
    await tester.tap(find.text('Create Order'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Review Order'));
    await tester.pumpAndSettle();

    expect(find.byType(ReviewOrderPage), findsOneWidget);
    expect(find.text('Order Total'), findsOneWidget);
    // The two line totals, then their sum.
    expect(find.text('₦24.50'), findsOneWidget);
    expect(find.text('₦18.90'), findsOneWidget);
    expect(find.text('₦43.40'), findsOneWidget);
  });

  testWidgets('review order pops back to the new order page', (tester) async {
    getIt<OrderDraftCubit>().addProduct(_coffee);

    await _pumpAtCustomerDetails(tester);
    await tester.tap(find.text('Create Order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review Order'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit Order'));
    await tester.pumpAndSettle();

    expect(find.byType(NewOrderPage), findsOneWidget);
    expect(find.byType(ReviewOrderPage), findsNothing);
  });

  Future<void> pumpAtReview(WidgetTester tester) async {
    getIt<OrderDraftCubit>()
      ..addProduct(_coffee)
      ..addProduct(_oil);

    await _pumpAtCustomerDetails(tester);
    await tester.tap(find.text('Create Order'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review Order'));
    await tester.pumpAndSettle();
  }

  Future<List<Order>> ordersWithStatus(
    WidgetTester tester,
    OrderStatus status,
  ) async {
    final result = await tester.runAsync(
      () => getIt<OrderRepository>().ordersByStatus(status),
    );

    return result!.getOrElse(() => []);
  }

  testWidgets('submitting online reports the order as sent', (tester) async {
    await pumpAtReview(tester);

    await tapThroughDatabase(tester, 'Submit Order');

    expect(find.text('Order Submitted!'), findsOneWidget);
    expect(find.byType(ReviewOrderPage), findsNothing);

    final state = getIt<SubmitOrderCubit>().state as SubmitOrderSucceeded;
    expect(state.order.status, OrderStatus.submitted);
    expect(state.order.total, closeTo(43.40, 0.001));

    final stored = await ordersWithStatus(tester, OrderStatus.submitted);
    expect(
      stored.map((order) => order.reference),
      contains(state.order.reference),
    );
  });

  testWidgets('submitting offline fails and keeps nothing', (tester) async {
    await pumpAtReview(tester);
    getIt<ConnectivityCubit>().setOnline(isOnline: false);

    await tapThroughDatabase(tester, 'Submit Order');

    expect(find.text('Submission Failed'), findsOneWidget);
    expect(find.text('Save as Pending'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    final reference =
        (getIt<SubmitOrderCubit>().state as SubmitOrderFailed).order.reference;
    final pending = await ordersWithStatus(tester, OrderStatus.pending);

    expect(pending.map((order) => order.reference), isNot(contains(reference)));
  });

  testWidgets('Save as Pending stores the order and clears the cart', (
    tester,
  ) async {
    await pumpAtReview(tester);
    getIt<ConnectivityCubit>().setOnline(isOnline: false);

    await tapThroughDatabase(tester, 'Submit Order');
    final reference =
        (getIt<SubmitOrderCubit>().state as SubmitOrderFailed).order.reference;
    await tapThroughDatabase(tester, 'Save as Pending');

    expect(find.byType(OrdersPage), findsOneWidget);
    expect(getIt<OrderDraftCubit>().state.isEmpty, isTrue);

    final pending = await ordersWithStatus(tester, OrderStatus.pending);
    expect(pending.map((order) => order.reference), contains(reference));
  });

  testWidgets('Retry after coming back online sends the same order', (
    tester,
  ) async {
    await pumpAtReview(tester);
    getIt<ConnectivityCubit>().setOnline(isOnline: false);

    await tapThroughDatabase(tester, 'Submit Order');
    final failedReference =
        (getIt<SubmitOrderCubit>().state as SubmitOrderFailed).order.reference;

    getIt<ConnectivityCubit>().setOnline(isOnline: true);
    await tapThroughDatabase(tester, 'Retry');

    expect(find.text('Order Submitted!'), findsOneWidget);
    expect(
      (getIt<SubmitOrderCubit>().state as SubmitOrderSucceeded).order.reference,
      failedReference,
    );
  });

  testWidgets('view cart asks who the order is for when no customer has been '
      'chosen', (tester) async {
    final router = await _pump(tester);
    router.go(const ProductsRoute().location);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('View Cart (1)'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCustomerPage), findsOneWidget);
  });

  testWidgets('choosing a customer from the picker opens the cart', (
    tester,
  ) async {
    final router = await _pump(tester);
    router.go(const ProductsRoute().location);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('View Cart (1)'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(CustomerListItem).first);
    await tester.pumpAndSettle();

    expect(find.byType(NewOrderPage), findsOneWidget);
    expect(getIt<OrderDraftCubit>().state.customer, isNotNull);
    expect(getIt<OrderDraftCubit>().state.productCount, 1);
  });
}
