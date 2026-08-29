import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/features/customers/domain/entities/customer.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_draft_cubit.dart';
import 'package:sales_pal/features/products/domain/entities/product.dart';

const _acme = Customer(
  id: '1',
  name: 'Acme Groceries Ltd.',
  location: 'Downtown Outlet',
  phoneNumber: '(555) 019-2831',
);

const _bayside = Customer(
  id: '2',
  name: 'Bayside Gourmet Store',
  location: 'Harbour Road',
  phoneNumber: '(555) 044-1190',
);

const _coffee = Product(
  id: 'PRD-001',
  name: 'Organic Premium Roast Coffee (1kg)',
  imagePath: 'assets/images/img_product_sample.png',
  stockUnits: 112,
  price: 24.50,
);

const _oil = Product(
  id: 'PRD-002',
  name: 'Extra Virgin Olive Oil (750ml)',
  imagePath: 'assets/images/img_product_sample.png',
  stockUnits: 45,
  price: 18.90,
);

const _lastTwo = Product(
  id: 'PRD-009',
  name: 'Single Origin Cocoa (250g)',
  imagePath: 'assets/images/img_product_sample.png',
  stockUnits: 2,
  price: 11.00,
);

const _soldOut = Product(
  id: 'PRD-010',
  name: 'Dark Chocolate Bars (Case of 24)',
  imagePath: 'assets/images/img_product_sample.png',
  stockUnits: 0,
  price: 41.75,
);

void main() {
  late OrderDraftCubit cubit;

  setUp(() => cubit = OrderDraftCubit());
  tearDown(() => cubit.close());

  group('OrderDraftCubit', () {
    test('starts empty with no customer', () {
      expect(cubit.state.customer, isNull);
      expect(cubit.state.isEmpty, isTrue);
      expect(cubit.state.subtotal, 0);
    });

    test('addProduct puts the product on the order at quantity one', () {
      cubit.addProduct(_coffee);

      expect(cubit.state.productCount, 1);
      expect(cubit.state.lines.single.quantity, 1);
      expect(cubit.state.contains(_coffee.id), isTrue);
    });

    test('addProduct ignores a product already on the order', () {
      cubit
        ..addProduct(_coffee)
        ..increment(_coffee.id)
        ..addProduct(_coffee);

      expect(cubit.state.productCount, 1);
      expect(cubit.state.lines.single.quantity, 2);
    });

    test('toggleProduct adds then removes', () {
      cubit.toggleProduct(_coffee);
      expect(cubit.state.contains(_coffee.id), isTrue);

      cubit.toggleProduct(_coffee);
      expect(cubit.state.contains(_coffee.id), isFalse);
    });

    test('increment and decrement move one line only', () {
      cubit
        ..addProduct(_coffee)
        ..addProduct(_oil)
        ..increment(_coffee.id)
        ..increment(_coffee.id);

      expect(cubit.state.lines.first.quantity, 3);
      expect(cubit.state.lines.last.quantity, 1);

      cubit.decrement(_coffee.id);
      expect(cubit.state.lines.first.quantity, 2);
    });

    test('increment stops at the available stock', () {
      cubit
        ..addProduct(_lastTwo)
        ..increment(_lastTwo.id)
        ..increment(_lastTwo.id)
        ..increment(_lastTwo.id);

      expect(cubit.state.entries.single.quantity, 2);
      expect(cubit.state.entries.single.isAtStockLimit, isTrue);
    });

    test('a product with no stock cannot be added', () {
      cubit.addProduct(_soldOut);

      expect(cubit.state.isEmpty, isTrue);
      expect(cubit.state.contains(_soldOut.id), isFalse);
    });

    test('toggling a sold-out product does nothing', () {
      cubit.toggleProduct(_soldOut);

      expect(cubit.state.isEmpty, isTrue);
    });

    test('the cap is per line, not across the order', () {
      cubit
        ..addProduct(_lastTwo)
        ..addProduct(_coffee)
        ..increment(_lastTwo.id)
        ..increment(_lastTwo.id)
        ..increment(_coffee.id);

      expect(cubit.state.entries.first.quantity, 2);
      expect(cubit.state.entries.last.quantity, 2);
      expect(cubit.state.entries.last.isAtStockLimit, isFalse);
    });

    test('decrement floors at one instead of emptying the line', () {
      cubit
        ..addProduct(_coffee)
        ..decrement(_coffee.id)
        ..decrement(_coffee.id);

      expect(cubit.state.lines.single.quantity, 1);
      expect(cubit.state.contains(_coffee.id), isTrue);
    });

    test('subtotal follows the lines', () {
      cubit
        ..addProduct(_coffee)
        ..increment(_coffee.id)
        ..addProduct(_oil);

      expect(cubit.state.subtotal, closeTo(67.90, 0.001));

      cubit.removeProduct(_coffee.id);
      expect(cubit.state.subtotal, closeTo(18.90, 0.001));
    });

    test('startFor attaches the customer to an empty draft', () {
      cubit.startFor(_acme);

      expect(cubit.state.customer, _acme);
      expect(cubit.state.isEmpty, isTrue);
    });

    test('startFor resumes the draft when it is the same customer', () {
      cubit
        ..startFor(_acme)
        ..addProduct(_coffee)
        ..startFor(_acme);

      expect(cubit.state.productCount, 1);
    });

    test('startFor discards the lines when the customer changes', () {
      cubit
        ..startFor(_acme)
        ..addProduct(_coffee)
        ..startFor(_bayside);

      expect(cubit.state.customer, _bayside);
      expect(cubit.state.isEmpty, isTrue);
    });

    test('startFor adopts a cart built before a customer was chosen', () {
      cubit
        ..addProduct(_coffee)
        ..addProduct(_oil)
        ..startFor(_acme);

      expect(cubit.state.customer, _acme);
      expect(cubit.state.productCount, 2);
    });

    test('clear empties both the customer and the lines', () {
      cubit
        ..startFor(_acme)
        ..addProduct(_coffee)
        ..clear();

      expect(cubit.state.customer, isNull);
      expect(cubit.state.isEmpty, isTrue);
    });
  });
}
