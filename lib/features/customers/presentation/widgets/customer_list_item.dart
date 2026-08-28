import 'package:flutter/material.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/design/components/app_badge.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/components/app_icon_label.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class CustomerListItem extends StatelessWidget {
  const CustomerListItem({super.key, required this.customer, this.onTap});

  final Customer customer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      customer.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _balanceBadge,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          AppIconLabel(
            icon: Assets.icons.icPhone,
            label: customer.phoneNumber,
            iconSize: AppIconSize.sm,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  AppBadge get _balanceBadge => customer.hasOutstandingBalance
      ? AppBadge(
          label: '${AppFormat.currency(customer.amountDue)} DUE',
          tone: AppBadgeTone.warning,
        )
      : const AppBadge(label: 'CLEARED');
}
