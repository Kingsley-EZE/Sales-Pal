class Product {
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
}
