import 'package:flutter/material.dart';
import 'package:sales_pal/design/radius.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/design/typography.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class AddProductButton extends StatelessWidget {
  const AddProductButton({
    super.key,
    required this.onPressed,
    this.isAdded = false,
  });

  final VoidCallback? onPressed;
  final bool isAdded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foregroundColor = isAdded ? colorScheme.onPrimary : colorScheme.primary;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isAdded ? colorScheme.primary : null,
        foregroundColor: foregroundColor,
        disabledForegroundColor: foregroundColor.withValues(alpha: 0.4),
        side: isAdded
            ? BorderSide.none
            : BorderSide(color: colorScheme.primary),
        textStyle: AppTypography.buttonLabelSmall,
        minimumSize: const Size(
          AppSize.compactButtonMinWidth,
          AppSize.compactTapTarget,
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: isAdded
          ? const Text('Added')
          : Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.xs,
              children: [
                Assets.icons.icPlus.svg(
                  width: AppIconSize.sm,
                  height: AppIconSize.sm,
                  colorFilter: ColorFilter.mode(
                    foregroundColor,
                    BlendMode.srcIn,
                  ),
                ),
                const Text('Add'),
              ],
            ),
    );
  }
}
