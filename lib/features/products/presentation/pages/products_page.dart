import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_action_footer.dart';
import 'package:sales_pal/design/components/app_status_view.dart';
import 'package:sales_pal/design/components/search_field.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';
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
        const _ViewCartBar(),
      ],
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDraftCubit, OrderDraft>(
      builder: (context, draft) => ListView.separated(
        itemCount: products.length,
        padding: const EdgeInsets.all(AppSpacing.md),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (context, index) {
          final product = products[index];

          return ProductListItem(
            product: product,
            isAdded: draft.contains(product.id),
            onAdd: () => context.read<OrderDraftCubit>().toggleProduct(product),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      ),
    );
  }
}

class _ViewCartBar extends StatelessWidget {
  const _ViewCartBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDraftCubit, OrderDraft>(
      builder: (context, draft) => AppActionFooter(
        primary: AppAction(
          label: draft.isEmpty
              ? 'View Cart'
              : 'View Cart (${draft.productCount})',
          onPressed: draft.isEmpty
              ? null
              : () => draft.customer == null
                    ? const SelectCustomerRoute().push(context)
                    : const NewOrderRoute().push(context),
        ),
      ),
    );
  }
}
