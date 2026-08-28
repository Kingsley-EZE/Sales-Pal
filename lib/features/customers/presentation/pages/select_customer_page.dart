import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/features/customers/presentation/widgets/customer_list_view.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';

class SelectCustomerPage extends StatelessWidget {
  const SelectCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Select Customer',
        subtitle: 'Choose who this order is for',
        showBackButton: true,
      ),
      body: SafeArea(
        child: CustomerListView(
          onCustomerTap: (customer) {
            context.read<OrderDraftCubit>().startFor(customer);
            const NewOrderRoute().pushReplacement(context);
          },
        ),
      ),
    );
  }
}
