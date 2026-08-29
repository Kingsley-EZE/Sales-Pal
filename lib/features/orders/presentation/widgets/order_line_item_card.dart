import 'package:flutter/material.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/semantic_colors.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';
import 'package:sales_pal/features/orders/presentation/widgets/quantity_stepper.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class OrderLineItemCard extends StatelessWidget {
  const OrderLineItemCard({
    super.key,
    required this.lineItem,
    this.availableUnits,
    this.canIncrement = true,
    this.onRemove,
    this.onDecrement,
    this.onIncrement,
  });

  final OrderLineItem lineItem;
  final int? availableUnits;

  final bool canIncrement;
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
                  lineItem.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
              ),
              IconButton(
                onPressed: onRemove,
                tooltip: 'Remove ${lineItem.productName}',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: AppIconSize.lg,
                  height: AppIconSize.lg,
                ),
                visualDensity: VisualDensity.compact,
                icon: Assets.icons.icTrash.svg(
                  width: AppIconSize.sm,
                  height: AppIconSize.sm,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurfaceVariant,
                    BlendMode.srcIn,
                  ),
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
                      'Unit Price: ${AppFormat.currency(lineItem.unitPrice)}',
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
                    if (availableUnits case final units? when !canIncrement)
                      Text(
                        'All $units in stock',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppSemanticColors.of(
                            context,
                          ).onWarningContainer,
                        ),
                      ),
                  ],
                ),
              ),
              QuantityStepper(
                quantity: lineItem.quantity,
                onDecrement: lineItem.quantity > 1 ? onDecrement : null,
                onIncrement: canIncrement ? onIncrement : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
