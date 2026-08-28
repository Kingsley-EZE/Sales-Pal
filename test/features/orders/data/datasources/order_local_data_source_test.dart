import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/data/app_database.dart';
import 'package:sales_pal/features/orders/data/datasources/order_local_data_source.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Order _order({
  String reference = 'FF-2026-0001',
  String customerId = 'CUS-001',
  String customerName = 'Acme Groceries Ltd.',
  DateTime? placedAt,
  OrderStatus status = OrderStatus.pending,
  List<OrderLineItem> lines = const [
    OrderLineItem(
      productId: 'PRD-001',
      productName: 'Organic Premium Roast Coffee (1kg)',
      unitPrice: 24.50,
      quantity: 2,
    ),
  ],
}) => Order(
  reference: reference,
  customerId: customerId,
  customerName: customerName,
  placedAt: placedAt ?? DateTime(2026, 8, 24),
  status: status,
  lines: lines,
);

void main() {
  sqfliteFfiInit();

  late Database db;
  late OrderLocalDataSource dataSource;

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) => AppDatabase.createSchema(db),
      ),
    );
    dataSource = OrderLocalDataSourceImpl(db);
  });

  tearDown(() => db.close());

  group('OrderLocalDataSource', () {
    test('round-trips an order and its lines', () async {
      final order = _order(
        lines: const [
          OrderLineItem(
            productId: 'PRD-001',
            productName: 'Coffee',
            unitPrice: 24.50,
            quantity: 2,
          ),
          OrderLineItem(
            productId: 'PRD-002',
            productName: 'Olive Oil',
            unitPrice: 18.90,
            quantity: 1,
          ),
        ],
      );

      await dataSource.save(order);

      expect(await dataSource.findByReference(order.reference), order);
    });

    test('total survives the round trip', () async {
      final order = _order();
      await dataSource.save(order);

      final stored = await dataSource.findByReference(order.reference);

      expect(stored!.total, 49.00);
      expect(stored.itemCount, 1);
    });

    test('saving the same reference twice replaces the lines', () async {
      await dataSource.save(_order());
      await dataSource.save(
        _order(
          lines: const [
            OrderLineItem(
              productId: 'PRD-009',
              productName: 'Something else',
              unitPrice: 1.00,
              quantity: 1,
            ),
          ],
        ),
      );

      final stored = await dataSource.findByReference('FF-2026-0001');

      expect(stored!.lines.single.productId, 'PRD-009');
      expect(await dataSource.ordersByStatus(OrderStatus.pending), [stored]);
    });

    test('filters by status', () async {
      await dataSource.save(_order(reference: 'A'));
      await dataSource.save(
        _order(reference: 'B', status: OrderStatus.submitted),
      );

      final pending = await dataSource.ordersByStatus(OrderStatus.pending);
      final submitted = await dataSource.ordersByStatus(OrderStatus.submitted);

      expect(pending.map((order) => order.reference), ['A']);
      expect(submitted.map((order) => order.reference), ['B']);
    });

    test('updateStatus promotes an order without touching its lines', () async {
      await dataSource.save(_order());

      await dataSource.updateStatus('FF-2026-0001', OrderStatus.submitted);
      final stored = await dataSource.findByReference('FF-2026-0001');

      expect(stored!.status, OrderStatus.submitted);
      expect(stored.lines, hasLength(1));
    });

    test('filters by customer, newest first', () async {
      await dataSource.save(
        _order(reference: 'OLD', placedAt: DateTime(2026, 1, 1)),
      );
      await dataSource.save(
        _order(reference: 'NEW', placedAt: DateTime(2026, 8, 1)),
      );
      await dataSource.save(_order(reference: 'OTHER', customerId: 'CUS-002'));

      final orders = await dataSource.ordersForCustomer('CUS-001');

      expect(orders.map((order) => order.reference), ['NEW', 'OLD']);
    });

    test('returns nothing for an unknown reference', () async {
      expect(await dataSource.findByReference('nope'), isNull);
      expect(await dataSource.ordersForCustomer('nobody'), isEmpty);
    });

    test('seeds the shipped fixtures', () async {
      await AppDatabase.seed(db, [
        {
          'reference': 'FF-2026-9412',
          'customerId': 'CUS-003',
          'customerName': 'Bayside Gourmet Store',
          'placedAt': '2026-08-24T16:30:00.000',
          'status': 'pending',
          'lines': [
            {
              'productId': 'PRD-005',
              'productName': 'Basmati Rice (5kg)',
              'unitPrice': 32.0,
              'quantity': 10,
            },
          ],
        },
      ]);

      final seeded = await dataSource.findByReference('FF-2026-9412');

      expect(seeded!.customerName, 'Bayside Gourmet Store');
      expect(seeded.status, OrderStatus.pending);
      expect(seeded.total, 320.0);
      expect(seeded.placedAt, DateTime.parse('2026-08-24T16:30:00.000'));
    });
  });
}
