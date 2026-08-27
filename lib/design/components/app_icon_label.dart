import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../sizes.dart';
import '../spacing.dart';

class AppIconLabel extends StatelessWidget {
  const AppIconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.style,
    this.iconSize = AppIconSize.sm,
  });

  final SvgGenImage icon;
  final String label;
  final TextStyle? style;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = style ?? theme.textTheme.bodyMedium;
    final color = textStyle?.color ?? theme.colorScheme.onSurface;

    return Row(
      spacing: AppSpacing.sm,
      children: [
        icon.svg(
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
