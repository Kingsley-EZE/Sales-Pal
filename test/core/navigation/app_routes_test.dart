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
import 'package:sales_pal/features/products/presentation/pages/products_page.dart';

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

  /// Create Order lands on the products tab, not on an empty cart.
  Future<void> startOrderFor(WidgetTester tester) async {
    await _pumpAtCustomerDetails(tester);
    await tester.tap(find.text('Create Order'));
    await tester.pumpAndSettle();
  }

  /// Walks the whole flow the way a rep would: pick a customer, add products,
  /// open the cart, review it.
  Future<void> pumpAtReview(WidgetTester tester) async {
    getIt<OrderDraftCubit>()
      ..addProduct(_coffee)
      ..addProduct(_oil);

    await startOrderFor(tester);
    await tester.tap(find.text('View Cart (2)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review Order'));
    await tester.pumpAndSettle();
  }

  testWidgets('create order sends the rep to the products tab', (tester) async {
    await _pumpAtCustomerDetails(tester);
    expect(find.byType(CustomerDetailsPage), findsOneWidget);

    await tester.tap(find.text('Create Order'));
    await tester.pumpAndSettle();

    expect(find.byType(ProductsPage), findsOneWidget);
    expect(find.byType(CustomerDetailsPage), findsNothing);
    // The pairing has to be visible, or the rep has no sign that what they
    // add next is going onto somebody's order.
    expect(find.text('Ordering for Acme Groceries Ltd.'), findsOneWidget);
    expect(getIt<OrderDraftCubit>().state.customer, _customer);
  });

  testWidgets('an empty cart cannot be opened', (tester) async {
    await startOrderFor(tester);

    final viewCart = tester.widget<OutlinedButton>(
      find.ancestor(
        of: find.text('View Cart'),
        matching: find.byType(OutlinedButton),
      ),
    );

    expect(viewCart.onPressed, isNull);
  });

  testWidgets('leaving products drops a customer with nothing added', (
    tester,
  ) async {
    await startOrderFor(tester);
    expect(getIt<OrderDraftCubit>().state.customer, _customer);

    await tester.tap(find.text('Customers'));
    await tester.pumpAndSettle();

    expect(getIt<OrderDraftCubit>().state.customer, isNull);
  });

  testWidgets('leaving products keeps a cart that has items', (tester) async {
    getIt<OrderDraftCubit>().addProduct(_coffee);
    await startOrderFor(tester);

    await tester.tap(find.text('Customers'));
    await tester.pumpAndSettle();

    // The rep's work survives; Cancel is how they discard it deliberately.
    expect(getIt<OrderDraftCubit>().state.customer, _customer);
    expect(getIt<OrderDraftCubit>().state.productCount, 1);
  });

  testWidgets('cancel discards an order that has not been started', (
    tester,
  ) async {
    await startOrderFor(tester);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Nothing to lose, so it goes without asking.
    expect(getIt<OrderDraftCubit>().state.customer, isNull);
    expect(find.text('Ordering for Acme Groceries Ltd.'), findsNothing);
  });

  testWidgets('cancel asks before throwing away a cart with items', (
    tester,
  ) async {
    getIt<OrderDraftCubit>().addProduct(_coffee);
    await startOrderFor(tester);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep'));
    await tester.pumpAndSettle();

    expect(getIt<OrderDraftCubit>().state.productCount, 1);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(getIt<OrderDraftCubit>().state.isEmpty, isTrue);
    expect(getIt<OrderDraftCubit>().state.customer, isNull);
  });

  testWidgets('view cart opens the order it belongs to', (tester) async {
    getIt<OrderDraftCubit>()
      ..addProduct(_coffee)
      ..addProduct(_oil);

    await startOrderFor(tester);
    await tester.tap(find.text('View Cart (2)'));
    await tester.pumpAndSettle();

    expect(find.byType(NewOrderPage), findsOneWidget);
    expect(find.text('Acme Groceries Ltd.'), findsOneWidget);
  });

  testWidgets('new order pushes the review order page', (tester) async {
    await pumpAtReview(tester);

    expect(find.byType(ReviewOrderPage), findsOneWidget);
    expect(find.text('Order Total'), findsOneWidget);
    // The two line totals, then their sum.
    expect(find.text('₦24.50'), findsOneWidget);
    expect(find.text('₦18.90'), findsOneWidget);
    expect(find.text('₦43.40'), findsOneWidget);
  });

  testWidgets('review order pops back to the new order page', (tester) async {
    await pumpAtReview(tester);

    await tester.tap(find.text('Edit Order'));
    await tester.pumpAndSettle();

    expect(find.byType(NewOrderPage), findsOneWidget);
    expect(find.byType(ReviewOrderPage), findsNothing);
  });

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
