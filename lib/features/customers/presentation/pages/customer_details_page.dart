import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_button.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
import 'package:sales_pal/features/customers/presentation/cubit/customer_orders_cubit.dart';
import 'package:sales_pal/features/customers/presentation/widgets/contact_information_card.dart';
import 'package:sales_pal/features/customers/presentation/widgets/outstanding_balance_card.dart';
import 'package:sales_pal/features/customers/presentation/widgets/recent_orders_card.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';

import '../../../../gen/assets.gen.dart';

class CustomerDetailsPage extends StatelessWidget {
  const CustomerDetailsPage({super.key, required this.customer});

  final Customer customer;

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
            BlocBuilder<CustomerOrdersCubit, CustomerOrdersState>(
              builder: (context, state) => switch (state) {
                CustomerOrdersLoading() => const RecentOrdersCard(orders: []),
                CustomerOrdersFailed(:final message) => RecentOrdersCard(
                  orders: const [],
                  emptyMessage: message,
                ),
                CustomerOrdersLoaded(:final orders) => RecentOrdersCard(
                  orders: orders,
                ),
              },
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        AppButton(
          label: "Create Order",
          icon: Assets.icons.icPlus.path,
          onPressed: () {
            context.read<OrderDraftCubit>().startFor(customer);
            const NewOrderRoute().push(context);
          },
        ),
      ],
    );
  }
}
