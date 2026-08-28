import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../sizes.dart';
import '../spacing.dart';
import '../typography.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBack,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;

  final Widget? trailing;

  static const _verticalPadding = AppSpacing.md;
  static const _backButtonSize = 40.0;

  static const trailingHeight = AppSize.compactTapTarget;

  @override
  Size get preferredSize {
    final titleBlockHeight =
        AppTypography.lineHeightOf(AppTypography.pageTitle) +
        (subtitle == null
            ? 0
            : AppTypography.lineHeightOf(AppTypography.pageSubtitle));

    final rowHeight = [
      titleBlockHeight,
      if (showBackButton) _backButtonSize,
      if (trailing != null) trailingHeight,
    ].reduce(math.max);

    return Size.fromHeight(
      _verticalPadding * 2 + rowHeight + AppSize.dividerThickness,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final dividerTheme = theme.dividerTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: dividerTheme.color ?? colorScheme.outlineVariant,
            width: AppSize.dividerThickness,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: _verticalPadding,
          ),
          child: Row(
            spacing: AppSpacing.md,
            children: [
              if (showBackButton) ...[
                IconButton(
                  onPressed: onBack ?? () => Navigator.maybePop(context),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    fixedSize: const Size.square(_backButtonSize),
                    minimumSize: const Size.square(_backButtonSize),
                    shape: const CircleBorder(),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Assets.icons.icChevronLeft.svg(
                    width: AppIconSize.md,
                    height: AppIconSize.md,
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineSmall,
                    ),
                    if (subtitle case final subtitle?)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
