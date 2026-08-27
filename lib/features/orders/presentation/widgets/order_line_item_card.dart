import 'package:flutter/material.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/order_line_item.dart';
import 'package:sales_pal/features/orders/presentation/widgets/quantity_stepper.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class OrderLineItemCard extends StatelessWidget {
  const OrderLineItemCard({
    super.key,
    required this.lineItem,
    this.onRemove,
    this.onDecrement,
    this.onIncrement,
  });

  final OrderLineItem lineItem;
  final VoidCallback? onRemove;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Text(
                  lineItem.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
              ),
              Assets.icons.icTrash.svg(
                width: AppIconSize.sm,
                height: AppIconSize.sm,
                colorFilter: ColorFilter.mode(
                  colorScheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unit Price: ${AppFormat.currency(lineItem.product.price)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Total: ${AppFormat.currency(lineItem.total)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              QuantityStepper(
                quantity: lineItem.quantity,
                onDecrement: onDecrement,
                onIncrement: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
