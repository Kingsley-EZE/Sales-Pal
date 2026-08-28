import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../mappers/product_mapper.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._dataSource);

  final ProductLocalDataSource _dataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final dtos = await _dataSource.fetchProducts();
      return Right(dtos.toEntities());
    } catch (_) {
      return const Left(DataFailure('Could not load products.'));
    }
  }
}
