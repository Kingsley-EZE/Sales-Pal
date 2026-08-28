import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_action_footer.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';
import 'package:sales_pal/features/orders/presentation/cubit/submit_order_cubit.dart';
import 'package:sales_pal/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class ReviewOrderPage extends StatelessWidget {
  const ReviewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<SubmitOrderCubit, SubmitOrderState>(
      listenWhen: (_, state) =>
          state is SubmitOrderSucceeded || state is SubmitOrderFailed,
      listener: (context, _) =>
          const OrderSubmissionStatusRoute().pushReplacement(context),
      child: BlocBuilder<OrderDraftCubit, OrderDraft>(
        builder: (context, draft) => Scaffold(
          appBar: AppTopBar(
            title: 'Review Order',
            subtitle: 'Please verify details before submission',
            showBackButton: true,
          ),
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                if (draft.customer case final customer?) ...[
                  AppCard(
                    child: Text(customer.name, style: textTheme.titleMedium),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                OrderSummaryCard(lineItems: draft.lines),
              ],
            ),
          ),
          bottomNavigationBar: _Footer(draft: draft),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.draft});

  final OrderDraft draft;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitOrderCubit, SubmitOrderState>(
      builder: (context, state) {
        final isSubmitting = state is SubmitOrderInProgress;
        final canSubmit =
            !isSubmitting && !draft.isEmpty && draft.customer != null;

        return AppActionFooter(
          primary: AppAction(
            label: isSubmitting ? 'Submitting…' : 'Submit Order',
            icon: isSubmitting ? null : Assets.icons.icCheck.path,
            onPressed: canSubmit ? () => _submit(context) : null,
          ),
          secondary: AppAction(
            label: 'Edit Order',
            onPressed: isSubmitting ? null : () => Navigator.maybePop(context),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    final customer = draft.customer;
    if (customer == null) return;

    context.read<SubmitOrderCubit>().submit(
      customerId: customer.id,
      customerName: customer.name,
      lines: draft.lines,
    );
  }
}
