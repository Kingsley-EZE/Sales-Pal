import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/design/components/app_status_view.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
import 'package:sales_pal/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:sales_pal/features/customers/presentation/widgets/customer_list_item.dart';


class CustomerListView extends StatelessWidget {
  const CustomerListView({super.key, required this.onCustomerTap});

  final ValueChanged<Customer> onCustomerTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersCubit, CustomersState>(
      builder: (context, state) => switch (state) {
        CustomersLoading() => const AppLoadingView(),
        CustomersFailed(:final message) => AppStatusView(
          message: message,
          onRetry: context.read<CustomersCubit>().load,
        ),
        CustomersLoaded(hasNoMatches: true, :final query) => AppStatusView(
          message: 'No customers match "${query.trim()}".',
        ),
        CustomersLoaded(:final visible) when visible.isEmpty =>
          const AppStatusView(message: 'No customers yet.'),
        CustomersLoaded(:final visible) => ListView.separated(
          itemCount: visible.length,
          padding: const EdgeInsets.all(AppSpacing.md),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (context, index) {
            final customer = visible[index];

            return CustomerListItem(
              customer: customer,
              onTap: () => onCustomerTap(customer),
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        ),
      },
    );
  }
}
