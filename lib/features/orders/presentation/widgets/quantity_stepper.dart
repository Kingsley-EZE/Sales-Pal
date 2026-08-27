import 'package:flutter/material.dart';
import 'package:sales_pal/design/radius.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    this.onDecrement,
    this.onIncrement,
  });

  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.sm,
      children: [
        _StepperButton(
          icon: Assets.icons.icMinus,
          onPressed: onDecrement,
          semanticLabel: 'Decrease quantity',
          iconWidth: 8,
          iconHeight: 3,
        ),
        Text('$quantity', style: theme.textTheme.titleMedium),
        _StepperButton(
          icon: Assets.icons.icPlus,
          onPressed: onIncrement,
          semanticLabel: 'Increase quantity',
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconWidth = AppIconSize.sm,
    this.iconHeight = AppIconSize.sm,
  });

  final SvgGenImage icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final double iconWidth, iconHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      tooltip: semanticLabel,
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHigh,
        fixedSize: const Size.square(AppSize.stepperButton),
        minimumSize: const Size.square(AppSize.stepperButton),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: icon.svg(
        width: iconWidth,
        height: iconHeight,
        colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
      ),
    );
  }
}
