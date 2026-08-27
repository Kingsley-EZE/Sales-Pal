import '../../../gen/assets.gen.dart';
import 'product.dart';

final sampleProducts = <Product>[
  Product(
    id: '1',
    name: 'Organic Premium Roast Coffee (1kg)',
    imagePath: Assets.images.imgProductSample.path,
    stockUnits: 112,
    price: 24.50,
  ),
  Product(
    id: '2',
    name: 'Extra Virgin Olive Oil (750ml)',
    imagePath: Assets.images.imgProductSample.path,
    stockUnits: 45,
    price: 18.90,
  ),
  Product(
    id: '3',
    name: 'Whole Grain Wheat Crackers (200g)',
    imagePath: Assets.images.imgProductSample.path,
    stockUnits: 320,
    price: 4.25,
  ),
  Product(
    id: '4',
    name: 'Unsweetened Almond Milk (1L)',
    imagePath: Assets.images.imgProductSample.path,
    stockUnits: 18,
    price: 5.10,
  ),
];
