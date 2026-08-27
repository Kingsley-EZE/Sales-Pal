import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/customers/domain/customer.dart';
import '../../features/customers/domain/sample_orders.dart';
import '../../features/customers/presentation/pages/customer_details_page.dart';
import '../../features/customers/presentation/pages/customers_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/products/presentation/pages/products_page.dart';

part 'app_routes.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

@TypedStatefulShellRoute<DashboardShellRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<CustomersBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<CustomersRoute>(
          path: '/customers',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<CustomerDetailsRoute>(path: ':customerId'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ProductsBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProductsRoute>(path: '/products'),
      ],
    ),
    TypedStatefulShellBranch<OrdersBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<OrdersRoute>(path: '/orders'),
      ],
    ),
  ],
)
final class DashboardShellRoute extends StatefulShellRouteData {
  const DashboardShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return DashboardPage(navigationShell: navigationShell);
  }
}

final class CustomersBranch extends StatefulShellBranchData {
  const CustomersBranch();
}

final class ProductsBranch extends StatefulShellBranchData {
  const ProductsBranch();
}

final class OrdersBranch extends StatefulShellBranchData {
  const OrdersBranch();
}

final class CustomersRoute extends GoRouteData with $CustomersRoute {
  const CustomersRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CustomersPage();
}

final class CustomerDetailsRoute extends GoRouteData
    with $CustomerDetailsRoute {
  const CustomerDetailsRoute({required this.customerId, required this.$extra});

  final String customerId;
  final Customer $extra;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CustomerDetailsPage(customer: $extra, recentOrders: sampleOrders);
}

final class ProductsRoute extends GoRouteData with $ProductsRoute {
  const ProductsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProductsPage();
}

final class OrdersRoute extends GoRouteData with $OrdersRoute {
  const OrdersRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const OrdersPage();
}
