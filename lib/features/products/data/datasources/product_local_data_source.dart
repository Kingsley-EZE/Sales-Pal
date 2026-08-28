import 'package:injectable/injectable.dart';

import '../../../../core/data/json_asset_loader.dart';
import '../dtos/product_dto.dart';

abstract interface class ProductLocalDataSource {
  Future<List<ProductDto>> fetchProducts();
}

@LazySingleton(as: ProductLocalDataSource)
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  const ProductLocalDataSourceImpl(this._loader);

  static const _assetPath = 'assets/data/products.json';

  final JsonAssetLoader _loader;

  @override
  Future<List<ProductDto>> fetchProducts() async {
    final rows = await _loader.loadList(_assetPath);
    return rows.map(ProductDto.fromJson).toList();
  }
}
