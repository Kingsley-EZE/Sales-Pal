import 'package:go_router/go_router.dart';

import 'app_routes.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: const CustomersRoute().location,
    routes: $appRoutes,
  );
}