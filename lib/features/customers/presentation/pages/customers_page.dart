import 'package:flutter/material.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/search_field.dart';
import 'package:sales_pal/features/customers/presentation/widgets/customer_list_view.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(hintText: "Search customers by name or location"),
        Expanded(
          child: CustomerListView(
            onCustomerTap: (customer) => CustomerDetailsRoute(
              customerId: customer.id,
              $extra: customer,
            ).push(context),
          ),
        ),
      ],
    );
  }
}
