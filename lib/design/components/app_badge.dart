import 'package:flutter/material.dart';

import '../radius.dart';
import '../semantic_colors.dart';
import '../spacing.dart';
import '../typography.dart';

enum AppBadgeTone {
  success,
  warning,
  neutral,
}

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
  });

  final String label;
  final AppBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semanticColors = AppSemanticColors.of(context);

    final (backgroundColor, foregroundColor) = switch (tone) {
      AppBadgeTone.success => (
        semanticColors.successContainer,
        semanticColors.onSuccessContainer,
      ),
      AppBadgeTone.warning => (
        semanticColors.warningContainer,
        semanticColors.onWarningContainer,
      ),
      AppBadgeTone.neutral => (
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: AppTypography.badgeLabel.copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}
