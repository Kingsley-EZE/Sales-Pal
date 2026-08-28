import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../orders/presentation/cubit/order_draft_cubit.dart';

import '../../design/components/app_top_bar.dart';
import '../../design/sizes.dart';
import '../../gen/assets.gen.dart';
import 'widgets/connectivity_indicator.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static final _destinations = <_DashboardDestination>[
    _DashboardDestination(
      label: 'Customers',
      icon: Assets.icons.icNavCustomers,
    ),
    _DashboardDestination(label: 'Products', icon: Assets.icons.icNavProducts),
    _DashboardDestination(
      label: 'Orders Queue',
      icon: Assets.icons.icNavOrders,
      subtitle: "Manage submissions and offline drafts",
    ),
  ];

  static const _productsIndex = 1;

  void _onDestinationSelected(BuildContext context, int index) {
    if (index != _productsIndex &&
        navigationShell.currentIndex == _productsIndex) {
      context.read<OrderDraftCubit>().abandonIfEmpty();
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationBarTheme = NavigationBarTheme.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerTheme = theme.dividerTheme;

    return Scaffold(
      appBar: AppTopBar(
        title: _destinations[navigationShell.currentIndex].label,
        subtitle: _destinations[navigationShell.currentIndex].subtitle,
        trailing: const ConnectivityIndicator(),
      ),
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: dividerTheme.color ?? colorScheme.outlineVariant,
              width: dividerTheme.thickness ?? AppSize.dividerThickness,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) =>
              _onDestinationSelected(context, index),
          destinations: [
            for (final destination in _destinations)
              NavigationDestination(
                label: destination.label,
                icon: destination.buildIcon(
                  navigationBarTheme,
                  selected: false,
                ),
                selectedIcon: destination.buildIcon(
                  navigationBarTheme,
                  selected: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DashboardDestination {
  const _DashboardDestination({
    required this.label,
    required this.icon,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
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
