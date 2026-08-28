part of 'products_cubit.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

final class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

final class ProductsLoaded extends ProductsState {
  const ProductsLoaded({required this.all, this.query = ''});

  final List<Product> all;
  final String query;

  List<Product> get visible =>
      query.trim().isEmpty ? all : all.where((p) => p.matches(query)).toList();

  bool get hasNoMatches => visible.isEmpty && all.isNotEmpty;

  ProductsLoaded copyWith({String? query}) =>
      ProductsLoaded(all: all, query: query ?? this.query);

  @override
  List<Object?> get props => [all, query];
}

final class ProductsFailed extends ProductsState {
  const ProductsFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
