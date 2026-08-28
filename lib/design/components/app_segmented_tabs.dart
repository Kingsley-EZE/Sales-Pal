import 'package:flutter/material.dart';

import '../radius.dart';
import '../sizes.dart';
import '../spacing.dart';

class AppSegmentedTabs extends StatelessWidget {
  const AppSegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            for (final (index, label) in labels.indexed)
              Expanded(
                child: _Segment(
                  label: label,
                  isSelected: index == selectedIndex,
                  onTap: onChanged == null ? null : () => onChanged!(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderRadius = BorderRadius.circular(AppRadius.sm);

    return Material(
      color: isSelected ? colorScheme.surfaceContainerLowest : Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          height: AppSize.compactTapTarget,
          alignment: Alignment.center,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
