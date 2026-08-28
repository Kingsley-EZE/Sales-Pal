import 'package:flutter/material.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/design/components/app_badge.dart';
import 'package:sales_pal/design/components/app_button.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/semantic_colors.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class OrderQueueCard extends StatelessWidget {
  const OrderQueueCard({
    super.key,
    required this.order,
    this.isExpanded = false,
    this.isRetrying = false,
    this.onToggle,
    this.onRetry,
  });

  final Order order;
  final bool isExpanded;
  final bool isRetrying;
  final VoidCallback? onToggle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final semanticColors = AppSemanticColors.of(context);

    return AppCard(
      onTap: onToggle,
      borderColor: isExpanded ? semanticColors.onWarningContainer : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Text(
                  order.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
              ),
              AppBadge(label: order.status.name.toUpperCase(), tone: _tone),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${AppFormat.mediumDate(order.placedAt)} • ${order.itemCount} items',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Value: ',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextSpan(
                        text: AppFormat.currency(order.total),
                        style: textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: isExpanded ? 2 : 0,
                child: Assets.icons.icChevronDown.svg(
                  width: AppIconSize.md,
                  height: AppIconSize.md,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            for (final line in order.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Expanded(
                      child: Text(
                        '${line.quantity}x ${line.productName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(
                      AppFormat.currency(line.total),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

            if (order.isPending) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: isRetrying ? 'Retrying…' : 'Retry Now',
                  icon: isRetrying ? null : Assets.icons.icRefresh.path,
                  onPressed: isRetrying ? null : onRetry,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  AppBadgeTone get _tone => switch (order.status) {
    OrderStatus.submitted => AppBadgeTone.success,
    OrderStatus.pending => AppBadgeTone.warning,
  };
}
