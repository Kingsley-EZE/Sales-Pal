import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../gen/assets.gen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static final _destinations = <_DashboardDestination>[
    _DashboardDestination(label: 'Customers', icon: Assets.icons.icNavCustomers),
    _DashboardDestination(label: 'Products', icon: Assets.icons.icNavProducts),
    _DashboardDestination(label: 'Orders', icon: Assets.icons.icNavOrders),
  ];

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_destinations[navigationShell.currentIndex].label),
      ),
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              label: destination.label,
              icon: destination.buildIcon(colorScheme.onSurfaceVariant),
              selectedIcon: destination.buildIcon(colorScheme.onSecondaryContainer),
            ),
        ],
      ),
    );
  }
}

class _DashboardDestination {
  const _DashboardDestination({required this.label, required this.icon});

  final String label;
  final SvgGenImage icon;

  Widget buildIcon(Color color) => icon.svg(
    width: 24,
    height: 24,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}