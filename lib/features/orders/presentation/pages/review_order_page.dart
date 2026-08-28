import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/design/components/app_action_footer.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/components/app_top_bar.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';
import 'package:sales_pal/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class ReviewOrderPage extends StatelessWidget {
  const ReviewOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<OrderDraftCubit, OrderDraft>(
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
                AppCard(child: Text(customer.name, style: textTheme.titleMedium)),
                const SizedBox(height: AppSpacing.md),
              ],
              OrderSummaryCard(lineItems: draft.lines),
            ],
          ),
        ),
        bottomNavigationBar: AppActionFooter(
          primary: AppAction(
            label: 'Submit Order',
            icon: Assets.icons.icCheck.path,
            onPressed: () {},
          ),
          secondary: AppAction(
            label: 'Edit Order',
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
    );
  }
}
