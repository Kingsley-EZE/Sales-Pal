import 'package:flutter/material.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/features/customers/domain/customer.dart';
import 'package:sales_pal/design/components/app_button.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/order_line_item.dart';
import 'package:sales_pal/features/orders/domain/sample_line_items.dart';
import 'package:sales_pal/features/orders/presentation/widgets/order_line_item_card.dart';

import '../../../../design/sizes.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key, required this.customer});

  /// The whole customer, not just a name: pushing the review route rebuilds
  /// this route and the customer details route above it, both of which read
  /// the customer back out of the navigation extra.
  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerTheme = theme.dividerTheme;
    final lineItems = sampleLineItems;

    return Scaffold(
      appBar: AppTopBar(
        title: 'New Order',
        subtitle: customer.name,
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                'Added line items (${lineItems.length})'.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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
                itemCount: lineItems.length,
                itemBuilder: (context, index) => OrderLineItemCard(
                  lineItem: lineItems[index],
                  onRemove: () {},
                  onDecrement: () {},
                  onIncrement: () {},
                ),
                separatorBuilder: (_, _) => const SizedBox(
                  height: AppSpacing.md,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: AppSpacing.md, right: AppSpacing.md,
                  bottom: AppSpacing.md, top: AppSpacing.xl
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: dividerTheme.color ?? colorScheme.outlineVariant,
                    width: dividerTheme.thickness ?? AppSize.dividerThickness,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Expanded(
                        child: Text(
                          'Order Subtotal',
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        AppFormat.currency(lineItems.subtotal),
                        style: theme.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: "Review Order",
                    onPressed: () => ReviewOrderRoute(
                      customerId: customer.id,
                      $extra: customer,
                    ).push(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
