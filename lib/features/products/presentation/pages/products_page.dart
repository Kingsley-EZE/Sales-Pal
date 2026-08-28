import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/design/components/app_status_view.dart';
import 'package:sales_pal/design/components/search_field.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/products/domain/entities/product.dart';
import 'package:sales_pal/features/products/presentation/cubit/products_cubit.dart';
import 'package:sales_pal/features/products/presentation/widgets/product_list_item.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(
          hintText: "Search products...",
          onChanged: context.read<ProductsCubit>().search,
        ),
        Expanded(
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) => switch (state) {
              ProductsLoading() => const AppLoadingView(),
              ProductsFailed(:final message) => AppStatusView(
                message: message,
                onRetry: context.read<ProductsCubit>().load,
              ),
              ProductsLoaded(hasNoMatches: true, :final query) => AppStatusView(
                message: 'No products match "${query.trim()}".',
              ),
              ProductsLoaded(:final visible) when visible.isEmpty =>
                const AppStatusView(message: 'No products available.'),
              ProductsLoaded(:final visible) => _ProductList(products: visible),
            },
          ),
        ),
      ],
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: products.length,
      padding: const EdgeInsets.all(AppSpacing.md),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) =>
          ProductListItem(product: products[index], onAdd: () {}),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
    );
  }
}
