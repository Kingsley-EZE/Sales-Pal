import 'package:flutter/material.dart';
import 'package:sales_pal/design/components/app_segmented_tabs.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/sample_queued_orders.dart';
import 'package:sales_pal/features/orders/presentation/widgets/order_queue_card.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  static const _selectedTab = 0;
  static const _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pendingOrders = sampleQueuedOrders;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppSegmentedTabs(
            labels: ['Pending (${pendingOrders.length})', 'Submitted'],
            selectedIndex: _selectedTab,
            onChanged: (_) {},
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            itemCount: pendingOrders.length,
            itemBuilder: (context, index) => OrderQueueCard(
              order: pendingOrders[index],
              isExpanded: index == _expandedIndex,
              onToggle: () {},
              onRetry: () {},
            ),
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
