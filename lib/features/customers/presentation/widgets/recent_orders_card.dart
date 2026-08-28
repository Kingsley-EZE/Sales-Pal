import 'package:flutter/material.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/customers/presentation/widgets/order_list_item.dart';

class RecentOrdersCard extends StatelessWidget {
  const RecentOrdersCard({
    super.key,
    required this.orders,
    this.emptyMessage = 'No orders yet',
  });

  final List<Order> orders;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      title: 'Recent orders',
      child: orders.isEmpty
          ? Text(
              emptyMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                for (final (index, order) in orders.indexed) ...[
                  if (index > 0) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  OrderListItem(order: order),
                ],
              ],
            ),
    );
  }
}
