import 'package:flutter/material.dart';
import 'package:sales_pal/core/navigation/app_routes.dart';
import 'package:sales_pal/design/components/app_action_footer.dart';
import 'package:sales_pal/design/components/app_badge.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/gen/assets.gen.dart';

enum OrderSubmissionStatus { succeeded, failed }


class OrderSubmissionStatusPage extends StatelessWidget {
  const OrderSubmissionStatusPage({
    super.key,
    required this.status,
    this.orderReference = 'FF-2026-9042',
    this.onSaveAsPending,
    this.onRetry,
  });

  final OrderSubmissionStatus status;
  final String orderReference;
  final VoidCallback? onSaveAsPending;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final (:icon, :title, :accent, :message, :reference) = switch (status) {
      OrderSubmissionStatus.succeeded => (
        icon: Assets.icons.icSubmissionSuccess,
        title: 'Order Submitted!',
        accent: colorScheme.primary,
        message:
            'Your order has been instantly synced with headquarters and sent '
            'down to the processing queue.',
        reference: orderReference,
      ),
      OrderSubmissionStatus.failed => (
        icon: Assets.icons.icSubmissionFailed,
        title: 'Submission Failed',
        accent: colorScheme.error,
        message:
            'It seems you are currently offline or experiencing weak internet '
            'connectivity.',
        reference: null,
      ),
    };

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
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
                message,
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
      bottomNavigationBar: _footer(context),
    );
  }

  Widget _footer(BuildContext context) => switch (status) {
    OrderSubmissionStatus.succeeded => AppActionFooter(
      primary: AppAction(
        label: 'Back to Customers',
        onPressed: () => const CustomersRoute().go(context),
      ),
    ),
    OrderSubmissionStatus.failed => AppActionFooter(
      primary: AppAction(label: 'Save as Pending', onPressed: onSaveAsPending),
      secondary: AppAction(
        label: 'Retry',
        icon: Assets.icons.icRefresh.path,
        onPressed: onRetry,
      ),
    ),
  };
}
