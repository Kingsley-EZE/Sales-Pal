import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_action_footer.dart';
import 'package:sales_pal/design/components/app_badge.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';
import 'package:sales_pal/features/orders/presentation/cubit/submit_order_cubit.dart';
import 'package:sales_pal/gen/assets.gen.dart';

/// Which outcome the page is reporting.
enum OrderSubmissionStatus { succeeded, failed }

/// The last screen of the submission flow, shown for both outcomes.
///
/// Which outcome and which order both come from [SubmitOrderCubit], so nothing
/// passed in can disagree with what actually happened.
///
/// The screen is terminal on purpose: a failed order exists nowhere but the
/// submission state, so leaving by any route other than Save as Pending or
/// Retry would drop it — and a submitted order should not be walked back into.
class OrderSubmissionStatusPage extends StatelessWidget {
  const OrderSubmissionStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<SubmitOrderCubit, SubmitOrderState>(
        builder: (context, state) => switch (state) {
          SubmitOrderSucceeded(:final order) => _Body(
            status: OrderSubmissionStatus.succeeded,
            reference: order.reference,
            // The order is done, so the cart it came from is spent.
            onPrimary: () => _leaveFor(context, const CustomersRoute().location),
          ),
          SubmitOrderFailed(:final failure) => _Body(
            status: OrderSubmissionStatus.failed,
            message: failure.message,
            onPrimary: () => _saveAsPending(context),
            onSecondary: context.read<SubmitOrderCubit>().retry,
          ),
          // Reached only by opening the route with nothing submitted.
          SubmitOrderIdle() || SubmitOrderInProgress() => const SizedBox.shrink(),
        },
      ),
    );
  }

  Future<void> _saveAsPending(BuildContext context) async {
    final submission = context.read<SubmitOrderCubit>();
    // Captured before the await, so nothing reaches for a BuildContext that
    // the navigation itself may have torn down.
    final leave = _leaver(context);

    await submission.saveAsPending();

    leave(const OrdersRoute().location);
  }

  void _leaveFor(BuildContext context, String destination) =>
      _leaver(context)(destination);

  void Function(String) _leaver(BuildContext context) {
    final draft = context.read<OrderDraftCubit>();
    final submission = context.read<SubmitOrderCubit>();
    final router = GoRouter.of(context);

    return (destination) {
      draft.clear();
      submission.reset();
      router.go(destination);
    };
  }
}

/// Everything but the actions is derived from [status], so the two variants
/// stay a single layout.
class _Body extends StatelessWidget {
  const _Body({
    required this.status,
    required this.onPrimary,
    this.reference,
    this.message,
    this.onSecondary,
  });

  final OrderSubmissionStatus status;
  final String? reference;
  final String? message;
  final VoidCallback onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final (:icon, :title, :accent, :body) = switch (status) {
      OrderSubmissionStatus.succeeded => (
        icon: Assets.icons.icSubmissionSuccess,
        title: 'Order Submitted!',
        accent: colorScheme.primary,
        body:
            'Your order has been instantly synced with headquarters and sent '
            'down to the processing queue.',
      ),
      OrderSubmissionStatus.failed => (
        icon: Assets.icons.icSubmissionFailed,
        title: 'Submission Failed',
        accent: colorScheme.error,
        body:
            message ??
            'It seems you are currently offline or experiencing weak internet '
                'connectivity.',
      ),
    };

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              // Weighted rather than centred, so the block sits high on the
              // page whether or not the badge and the second button are there.
              const Spacer(),
              icon.svg(
                width: AppSize.statusIllustration,
                height: AppSize.statusIllustration,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(color: accent),
              ),
              if (reference case final reference?) ...[
                const SizedBox(height: AppSpacing.md),
                AppBadge(label: 'Order #$reference'.toUpperCase()),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                body,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
      bottomNavigationBar: switch (status) {
        OrderSubmissionStatus.succeeded => AppActionFooter(
          primary: AppAction(label: 'Back to Customers', onPressed: onPrimary),
        ),
        OrderSubmissionStatus.failed => AppActionFooter(
          primary: AppAction(label: 'Save as Pending', onPressed: onPrimary),
          secondary: AppAction(
            label: 'Retry',
            icon: Assets.icons.icRefresh.path,
            onPressed: onSecondary,
          ),
        ),
      },
    );
  }
}
