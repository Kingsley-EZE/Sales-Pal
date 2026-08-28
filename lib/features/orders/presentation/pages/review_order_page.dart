import 'package:flutter/material.dart';
import 'package:sales_pal/design/components/app_action_footer.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/sample_line_items.dart';
import 'package:sales_pal/features/orders/presentation/widgets/order_summary_card.dart';

import '../../../../gen/assets.gen.dart';

class ReviewOrderPage extends StatelessWidget {
  const ReviewOrderPage({
    super.key,
    this.customerName = 'Acme Groceries Ltd.',
  });

  final String customerName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final lineItems = sampleLineItems;

    return Scaffold(
      appBar: AppTopBar(
        title: "Review Order",
        subtitle: "Please verify details before submission",
        showBackButton: true,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Text(customerName, style: textTheme.titleMedium),
            ),
            const SizedBox(height: AppSpacing.md),
            OrderSummaryCard(lineItems: lineItems),
          ],
        ),
      ),
      bottomNavigationBar: AppActionFooter(
        primary: AppAction(
            label: 'Submit Order',
            icon: Assets.icons.icCheck.path,
            onPressed: () {}),
        secondary: AppAction(
          label: 'Edit Order',
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}
