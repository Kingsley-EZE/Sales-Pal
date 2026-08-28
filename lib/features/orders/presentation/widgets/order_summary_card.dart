import 'package:flutter/material.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.lineItems});

  final List<OrderLineItem> lineItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppCard(
      title: 'Items summary',
      titleStyle: textTheme.labelMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final lineItem in lineItems) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(lineItem: lineItem),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Text('Order Total', style: textTheme.titleSmall),
              ),
              Text(
                AppFormat.currency(lineItems.subtotal),
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.lineItem});

  final OrderLineItem lineItem;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${lineItem.quantity}x ',
                  style: textTheme.labelLarge,
                ),
                TextSpan(text: lineItem.productName),
              ],
            ),
            style: textTheme.bodyMedium,
          ),
        ),
        Text(
          AppFormat.currency(lineItem.total),
          style: textTheme.labelLarge,
        ),
      ],
    );
  }
}
