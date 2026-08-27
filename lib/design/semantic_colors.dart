import 'package:flutter/material.dart';

final class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;

  final Color warningContainer;
  final Color onWarningContainer;

  static const light = AppSemanticColors(
    success: Color(0xFF2E7D32),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFED6C02),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFEF6E9),
    onWarningContainer: Color(0xFFF5A623),
  );

  static const dark = AppSemanticColors(
    success: Color(0xFF81C784),
    onSuccess: Color(0xFF07290A),
    warning: Color(0xFFFFB74D),
    onWarning: Color(0xFF3B2200),
    warningContainer: Color(0xFF3B2A12),
    onWarningContainer: Color(0xFFF5A623),
  );

  static AppSemanticColors of(BuildContext context) =>
      Theme.of(context).extension<AppSemanticColors>() ?? light;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;

    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSemanticColors &&
        other.success == success &&
        other.onSuccess == onSuccess &&
        other.warning == warning &&
        other.onWarning == onWarning &&
        other.warningContainer == warningContainer &&
        other.onWarningContainer == onWarningContainer;
  }

  @override
  int get hashCode => Object.hash(
    success,
    onSuccess,
    warning,
    onWarning,
    warningContainer,
    onWarningContainer,
  );
}
