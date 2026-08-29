import 'package:flutter/material.dart';
import 'package:sales_pal/core/format/app_format.dart';
import 'package:sales_pal/design/components/app_card.dart';
import 'package:sales_pal/design/radius.dart';
import 'package:sales_pal/design/sizes.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/products/domain/entities/product.dart';
import 'package:sales_pal/features/products/presentation/widgets/add_product_button.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    super.key,
    required this.product,
    this.onAdd,
    this.isAdded = false,
  });

  final Product product;
  final VoidCallback? onAdd;
  final bool isAdded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Image.asset(
              product.imagePath,
              width: AppSize.productThumbnail,
              height: AppSize.productThumbnail,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  product.isInStock
                      ? 'Stock: ${product.stockUnits} units'
                      : 'Out of stock',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: product.isInStock
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Expanded(
                      child: Text(
                        AppFormat.currency(product.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary, fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    AddProductButton(
                      onPressed: product.isInStock ? onAdd : null,
                      isAdded: isAdded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
