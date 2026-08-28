import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/connectivity/connectivity_cubit.dart';
import 'package:sales_pal/core/data/app_database.dart';
import 'package:sales_pal/core/error/failure.dart';
import 'package:sales_pal/features/orders/data/datasources/order_api_service.dart';
import 'package:sales_pal/features/orders/data/datasources/order_local_data_source.dart';
import 'package:sales_pal/features/orders/data/repositories/order_repository_impl.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/orders/domain/entities/order_line_item.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../../support/fake_connectivity_monitor.dart';

final _order = Order(
  reference: 'FF-2026-0001',
  customerId: 'CUS-001',
  customerName: 'Acme Groceries Ltd.',
  placedAt: DateTime(2026, 8, 24),
  status: OrderStatus.pending,
  lines: const [
    OrderLineItem(
      productId: 'PRD-001',
      productName: 'Organic Premium Roast Coffee (1kg)',
      unitPrice: 24.50,
      quantity: 2,
    ),
  ],
);

void main() {
  sqfliteFfiInit();

  late Database db;
  late OrderLocalDataSource local;
  late ConnectivityCubit connectivity;
  late OrderRepositoryImpl repository;

  setUp(() async {
    OrderApiService.latency = Duration.zero;

    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) => AppDatabase.createSchema(db),
      ),
    );
    local = OrderLocalDataSourceImpl(db);
    connectivity = ConnectivityCubit(FakeConnectivityMonitor());
    repository = OrderRepositoryImpl(OrderApiService(connectivity), local);
  });

  tearDown(() async {
    await connectivity.close();
    await db.close();
  });

  group('submit', () {
    test('stores the order as submitted when online', () async {
      final result = await repository.submit(_order);

      expect(result.isRight(), isTrue);
      expect(
        result.getOrElse(() => throw StateError('expected success')).status,
        OrderStatus.submitted,
      );

      final stored = await local.findByReference(_order.reference);
      expect(stored!.status, OrderStatus.submitted);
      expect(stored.lines, hasLength(1));
    });

    test('stores nothing when offline', () async {
      connectivity.setOnline(isOnline: false);

      final result = await repository.submit(_order);

      expect(
        result.swap().getOrElse(() => throw StateError('expected failure')),
        isA<OfflineFailure>(),
      );
      expect(await local.findByReference(_order.reference), isNull);
      expect(await local.ordersByStatus(OrderStatus.pending), isEmpty);
    });
  });

  group('saveAsPending', () {
    test('keeps a failed order in the queue', () async {
      connectivity.setOnline(isOnline: false);
      await repository.submit(_order);

      final result = await repository.saveAsPending(_order);

      expect(result.isRight(), isTrue);

      final stored = await local.findByReference(_order.reference);
      expect(stored!.status, OrderStatus.pending);
      expect(stored.total, 49.00);
    });

    test('a kept order survives a new handle on the same database', () async {
      connectivity.setOnline(isOnline: false);
      await repository.submit(_order);
      await repository.saveAsPending(_order);

      final reopened = OrderLocalDataSourceImpl(db);

      expect(
        (await reopened.ordersByStatus(OrderStatus.pending)).single.reference,
        _order.reference,
      );
    });

    test('retrying after coming back online promotes it', () async {
      connectivity.setOnline(isOnline: false);
      await repository.submit(_order);
      await repository.saveAsPending(_order);

      connectivity.setOnline(isOnline: true);
      final result = await repository.submit(_order);

      expect(result.isRight(), isTrue);

      final stored = await local.findByReference(_order.reference);
      expect(stored!.status, OrderStatus.submitted);
      expect(await local.ordersByStatus(OrderStatus.pending), isEmpty);
    });
  });
}
