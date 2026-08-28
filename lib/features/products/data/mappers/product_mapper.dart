import '../../domain/entities/product.dart';
import '../dtos/product_dto.dart';

extension ProductDtoMapper on ProductDto {
  Product toEntity() => Product(
    id: id,
    name: name,
    imagePath: imagePath,
    stockUnits: stockUnits,
    price: price,
  );
}

extension ProductDtoListMapper on List<ProductDto> {
  List<Product> toEntities() => map((dto) => dto.toEntity()).toList();
}
