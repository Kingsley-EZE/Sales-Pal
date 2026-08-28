import 'package:flutter/material.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/components/app_icon_label.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
import 'package:sales_pal/gen/assets.gen.dart';

class ContactInformationCard extends StatelessWidget {
  const ContactInformationCard({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Contact information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          const SizedBox(height: AppSpacing.xs),
          AppIconLabel(
            icon: Assets.icons.icPhone,
            label: customer.phoneNumber,
          ),
          AppIconLabel(
            icon: Assets.icons.icMapPin,
            label: customer.location,
          ),
        ],
      ),
    );
  }
}
