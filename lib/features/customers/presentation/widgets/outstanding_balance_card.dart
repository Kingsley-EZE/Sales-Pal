import 'package:flutter/material.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/semantic_colors.dart';

class OutstandingBalanceCard extends StatelessWidget {
  const OutstandingBalanceCard({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = AppSemanticColors.of(context);

    return AppCard(
      title: 'Outstanding balance',
      titleColor: semanticColors.onWarningContainer,
      backgroundColor: semanticColors.warningContainer,
      borderColor: semanticColors.onWarningContainer,
      child: Text(
        AppFormat.currency(amount),
        style: textTheme.headlineMedium,
      ),
    );
  }
}
