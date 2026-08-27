import 'package:flutter/material.dart';

import '../radius.dart';
import '../sizes.dart';
import '../spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.titleColor,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
  });

  final Widget child;
  final String? title;
  final Color? titleColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: borderColor ?? colorScheme.outlineVariant,
          width: AppSize.dividerThickness,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title case final title?) ...[
                  Text(
                    title.toUpperCase(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: titleColor, fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
