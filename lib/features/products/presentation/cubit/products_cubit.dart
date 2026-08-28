import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

part 'products_state.dart';

@injectable
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsLoading());

  final ProductRepository _repository;

  Future<void> load() async {
    emit(const ProductsLoading());

    final result = await _repository.getProducts();

    emit(
      result.fold(
        (failure) => ProductsFailed(failure.message),
        (products) => ProductsLoaded(all: products),
      ),
    );
  }


  void search(String query) {
    final current = state;
    if (current is! ProductsLoaded) return;

    emit(current.copyWith(query: query));
  }
}
