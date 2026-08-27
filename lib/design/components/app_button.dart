import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../sizes.dart';
import '../spacing.dart';

enum AppButtonType {
  primary,
  secondary,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPrimary = type == AppButtonType.primary;

    final backgroundColor = isPrimary
        ? colorScheme.primary
        : colorScheme.surface;
    final foregroundColor = isPrimary
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.4),
        disabledForegroundColor: foregroundColor.withValues(alpha: 0.4),
        side: isPrimary
            ? BorderSide.none
            : BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            SvgPicture.asset(
              icon!,
              width: AppIconSize.md,
              height: AppIconSize.md,
              colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(label),
        ],
      ),
    );
  }
}
