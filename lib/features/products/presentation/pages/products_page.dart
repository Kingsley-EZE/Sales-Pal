import 'package:flutter/material.dart';
import 'package:sales_pal/design/components/search_field.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/products/domain/sample_products.dart';
import 'package:sales_pal/features/products/presentation/widgets/product_list_item.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(hintText: "Search products..."),
        Expanded(
          child: ListView.separated(
            itemCount: sampleProducts.length,
            padding: EdgeInsets.all(AppSpacing.md),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (context, index) =>
                ProductListItem(product: sampleProducts[index], onAdd: () {}),
            separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
