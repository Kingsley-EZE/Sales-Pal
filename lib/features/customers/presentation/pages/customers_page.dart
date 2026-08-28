import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_status_view.dart';
import 'package:sales_pal/design/components/search_field.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
import 'package:sales_pal/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:sales_pal/features/customers/presentation/widgets/customer_list_item.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(hintText: "Search customers by name or location"),
        Expanded(
          child: BlocBuilder<CustomersCubit, CustomersState>(
            builder: (context, state) => switch (state) {
              CustomersLoading() => const AppLoadingView(),
              CustomersFailed(:final message) => AppStatusView(
                message: message,
                onRetry: context.read<CustomersCubit>().load,
              ),
              CustomersLoaded(:final customers) when customers.isEmpty =>
                const AppStatusView(message: 'No customers yet.'),
              CustomersLoaded(:final customers) => _CustomerList(
                customers: customers,
              ),
            },
          ),
        ),
      ],
    );
  }
}

class _CustomerList extends StatelessWidget {
  const _CustomerList({required this.customers});

  final List<Customer> customers;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: customers.length,
      padding: const EdgeInsets.all(AppSpacing.md),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) {
        final customer = customers[index];

        return CustomerListItem(
          customer: customer,
          onTap: () => CustomerDetailsRoute(
            customerId: customer.id,
            $extra: customer,
          ).push(context),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
    );
  }
}
