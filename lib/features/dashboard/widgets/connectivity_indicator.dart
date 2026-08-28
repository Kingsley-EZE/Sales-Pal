import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/connectivity/connectivity_cubit.dart';
import '../../../design/components/app_top_bar.dart';
import '../../../design/radius.dart';
import '../../../design/semantic_colors.dart';
import '../../../design/spacing.dart';
import '../../../design/typography.dart';


class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});

  static const _dotSize = 8.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semanticColors = AppSemanticColors.of(context);

    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isOnline) {
        final (background, foreground) = isOnline
            ? (
                semanticColors.successContainer,
                semanticColors.onSuccessContainer,
              )
            : (colorScheme.errorContainer, colorScheme.error);

        return Semantics(
          liveRegion: true,
          label: isOnline ? 'Online' : 'Offline',
          excludeSemantics: true,
          child: Container(
            height: AppTopBar.trailingHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.sm,
              children: [
                Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: foreground,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: AppTypography.badgeLabel.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
