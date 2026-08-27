import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../sizes.dart';
import '../spacing.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key, this.hintText = "Search", this.onChanged});

  final String hintText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: colorScheme.surfaceContainerLowest,
      child: SearchBar(
        hintText: hintText,
        textCapitalization: TextCapitalization.none,
        onChanged: onChanged,
        leading: Assets.icons.icSearch.svg(
          width: AppIconSize.md,
          height: AppIconSize.md,
          colorFilter: ColorFilter.mode(
            colorScheme.onSurfaceVariant,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
