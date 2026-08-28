import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_button.dart';
import 'package:sales_pal/design/components/app_status_view.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';
import 'package:sales_pal/features/orders/presentation/widgets/order_line_item_card.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDraftCubit, OrderDraft>(
      builder: (context, draft) => Scaffold(
        appBar: AppTopBar(
          title: 'New Order',
          subtitle: draft.customer?.name,
          showBackButton: true,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Text(
                  'Added items (${draft.productCount})'.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: draft.isEmpty
                    ? const AppStatusView(
                        message:
                            'Nothing on this order yet.\n'
                            'Add products from the Products tab.',
                      )
                    : _LineItemList(lines: draft.lines),
              ),
              _SubtotalFooter(draft: draft),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineItemList extends StatelessWidget {
  const _LineItemList({required this.lines});

  final List<OrderLineItem> lines;

  @override
  Widget build(BuildContext context) {
    final draft = context.read<OrderDraftCubit>();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index];

        return OrderLineItemCard(
          lineItem: line,
          onRemove: () => draft.removeProduct(line.productId),
          onDecrement: () => draft.decrement(line.productId),
          onIncrement: () => draft.increment(line.productId),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
    );
  }
}

class _SubtotalFooter extends StatelessWidget {
  const _SubtotalFooter({required this.draft});

  final OrderDraft draft;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerTheme = theme.dividerTheme;

    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
        top: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: dividerTheme.color ?? colorScheme.outlineVariant,
            width: dividerTheme.thickness ?? AppSize.dividerThickness,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Text('Order Subtotal', style: theme.textTheme.titleSmall),
              ),
              Text(
                AppFormat.currency(draft.subtotal),
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Review Order',
            onPressed: draft.isEmpty
                ? null
                : () => const ReviewOrderRoute().push(context),
          ),
        ],
      ),
    );
  }
}
