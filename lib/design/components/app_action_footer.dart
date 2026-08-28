import 'package:flutter/material.dart';

import '../sizes.dart';
import '../spacing.dart';
import 'app_button.dart';

class AppAction {
  const AppAction({required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final String? icon;
}

class AppActionFooter extends StatelessWidget {
  const AppActionFooter({
    super.key,
    required this.primary,
    this.secondary,
    this.leading,
  });

  final AppAction primary;
  final AppAction? secondary;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerTheme = theme.dividerTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color: dividerTheme.color ?? colorScheme.outlineVariant,
            width: dividerTheme.thickness ?? AppSize.dividerThickness,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (leading case final leading?) ...[
                leading,
                const SizedBox(height: AppSpacing.md),
              ],
              _button(primary, AppButtonType.primary),
              if (secondary case final secondary?) ...[
                const SizedBox(height: AppSpacing.sm),
                _button(secondary, AppButtonType.secondary),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(AppAction action, AppButtonType type) => AppButton(
    label: action.label,
    icon: action.icon,
    onPressed: action.onPressed,
    type: type,
  );
}
