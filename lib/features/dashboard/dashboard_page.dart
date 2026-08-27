import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/app_top_bar.dart';
import '../../design/sizes.dart';
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
    final navigationBarTheme = NavigationBarTheme.of(context);

    return Scaffold(
      appBar: AppTopBar(
        title: _destinations[navigationShell.currentIndex].label,
      ),
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              label: destination.label,
              icon: destination.buildIcon(navigationBarTheme, selected: false),
              selectedIcon: destination.buildIcon(
                navigationBarTheme,
                selected: true,
              ),
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

  Widget buildIcon(NavigationBarThemeData theme, {required bool selected}) {
    final iconTheme = theme.iconTheme?.resolve(
      selected ? {WidgetState.selected} : <WidgetState>{},
    );
    final size = iconTheme?.size ?? AppIconSize.lg;
    final color = iconTheme?.color;

    return icon.svg(
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
