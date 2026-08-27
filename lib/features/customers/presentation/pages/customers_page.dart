import 'package:flutter/material.dart';
import 'package:sales_pal/design/components/search_field.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/customers/domain/customer.dart';
import 'package:sales_pal/features/customers/presentation/widgets/customer_list_item.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(
          hintText: "Search customers by name or location",
        ),
        Expanded(
            child: ListView.separated(
                itemCount: 5,
                padding: EdgeInsets.all(AppSpacing.md),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (context, index) {
                  final customer = Customer(
                      id: "$index",
                      name: "James King $index",
                      location: "London, UK",
                      amountDue: index % 2 == 0 ? 1000 : 0,
                      phoneNumber: "234 906 4076 767");
                  return CustomerListItem(customer: customer);
                },
              separatorBuilder: (_,__)=> SizedBox(height: AppSpacing.md),
            )
        )
      ],
    );
  }
}
