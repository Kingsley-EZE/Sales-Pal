import 'package:flutter/material.dart';

import '../spacing.dart';
import 'app_button.dart';


class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}


class AppStatusView extends StatelessWidget {
  const AppStatusView({
    super.key,
    required this.message,
    this.actionLabel,
    this.onRetry,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry case final onRetry?) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: actionLabel ?? 'Try again',
                type: AppButtonType.secondary,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
