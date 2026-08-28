import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_action_footer.dart';
import 'package:sales_pal/design/components/app_status_view.dart';
import 'package:sales_pal/design/components/search_field.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/design/typography.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
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
        leading: switch (draft.customer) {
          final customer? => _OrderingFor(customer: customer),
          null => null,
        },
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


class _OrderingFor extends StatelessWidget {
  const _OrderingFor({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      spacing: AppSpacing.sm,
      children: [
        Expanded(
          child: Text(
            'Ordering for ${customer.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _cancel(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            minimumSize: const Size(0, AppSize.compactTapTarget),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: AppTypography.buttonLabelSmall,
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final draft = context.read<OrderDraftCubit>();

    if (!draft.state.isEmpty && !await _confirmedDiscard(context)) return;

    draft.clear();
  }

  Future<bool> _confirmedDiscard(BuildContext context) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard this order?'),
        content: Text(
          'The items you added for ${customer.name} will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return discard ?? false;
  }
}
