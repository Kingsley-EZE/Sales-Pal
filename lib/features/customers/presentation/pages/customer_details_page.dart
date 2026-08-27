import 'package:flutter/material.dart';
import 'package:sales_pal/design/components/app_button.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/customers/domain/customer.dart';
import 'package:sales_pal/features/customers/domain/order.dart';
import 'package:sales_pal/features/customers/presentation/widgets/contact_information_card.dart';
import 'package:sales_pal/features/customers/presentation/widgets/outstanding_balance_card.dart';
import 'package:sales_pal/features/customers/presentation/widgets/recent_orders_card.dart';

import '../../../../gen/assets.gen.dart';

class CustomerDetailsPage extends StatelessWidget {
  const CustomerDetailsPage({
    super.key,
    required this.customer,
    this.recentOrders = const [],
  });

  final Customer customer;
  final List<Order> recentOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: customer.name,
        subtitle: customer.location,
        showBackButton: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (customer.hasOutstandingBalance) ...[
              OutstandingBalanceCard(amount: customer.amountDue),
              const SizedBox(height: AppSpacing.md),
            ],
            ContactInformationCard(customer: customer),
            const SizedBox(height: AppSpacing.md),
            RecentOrdersCard(orders: recentOrders),
          ],
        ),
      ),
      persistentFooterButtons: [
        AppButton(
            label: "Create Order",
            icon: Assets.icons.icPlus.path,
            onPressed: () {}),
      ],
    );
  }
}
