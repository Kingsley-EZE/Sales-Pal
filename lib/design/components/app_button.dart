import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  static const _borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPrimary = type == AppButtonType.primary;

    final backgroundColor = isPrimary ? colorScheme.primary : colorScheme.surface;
    final foregroundColor = isPrimary ? colorScheme.onPrimary : colorScheme.onSurface;
    final borderSide = isPrimary
        ? BorderSide.none
        : BorderSide(color: colorScheme.outlineVariant);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.4),
        disabledForegroundColor: foregroundColor.withValues(alpha: 0.4),
        side: borderSide,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            SvgPicture.asset(
              icon!,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
