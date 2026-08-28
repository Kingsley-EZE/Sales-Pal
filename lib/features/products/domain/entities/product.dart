import 'package:equatable/equatable.dart';


class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.stockUnits,
    required this.price,
  });

  final String id;
  final String name;
  final String imagePath;
  final int stockUnits;
  final double price;

  bool get isInStock => stockUnits > 0;

  bool matches(String query) =>
      name.toLowerCase().contains(query.trim().toLowerCase());

  @override
  List<Object?> get props => [id, name, imagePath, stockUnits, price];
}
