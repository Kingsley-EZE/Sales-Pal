import 'package:equatable/equatable.dart';

class ProductDto extends Equatable {
  const ProductDto({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.stockUnits,
    required this.price,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) => ProductDto(
    id: json['id'] as String,
    name: json['name'] as String,
    imagePath: json['imagePath'] as String,
    stockUnits: json['stockUnits'] as int,
    price: (json['price'] as num).toDouble(),
  );

  final String id;
  final String name;
  final String imagePath;
  final int stockUnits;
  final double price;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imagePath': imagePath,
    'stockUnits': stockUnits,
    'price': price,
  };

  @override
  List<Object?> get props => [id, name, imagePath, stockUnits, price];
}
