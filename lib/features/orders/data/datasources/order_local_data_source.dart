import 'package:injectable/injectable.dart' hide Order;
import 'package:sqflite/sqflite.dart';

import '../../../../core/data/app_database.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_line_item.dart';

abstract interface class OrderLocalDataSource {
  Future<void> save(Order order);

  Future<void> updateStatus(String reference, OrderStatus status);

  Future<List<Order>> ordersByStatus(OrderStatus status);

  Future<List<Order>> ordersForCustomer(String customerId);

  Future<Order?> findByReference(String reference);
}

@LazySingleton(as: OrderLocalDataSource)
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  const OrderLocalDataSourceImpl(this._db);

  final Database _db;

  @override
  Future<void> save(Order order) => _db.transaction((txn) async {
    await txn.insert(
      OrderTable.name,
      _orderRow(order),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await txn.delete(
      OrderLineTable.name,
      where: '${OrderLineTable.orderReference} = ?',
      whereArgs: [order.reference],
    );

    for (final line in order.lines) {
      await txn.insert(OrderLineTable.name, _lineRow(order.reference, line));
    }
  });

  @override
  Future<void> updateStatus(String reference, OrderStatus status) => _db.update(
    OrderTable.name,
    {OrderTable.status: status.name},
    where: '${OrderTable.reference} = ?',
    whereArgs: [reference],
  );

  @override
  Future<List<Order>> ordersByStatus(OrderStatus status) => _query(
    where: '${OrderTable.status} = ?',
    whereArgs: [status.name],
  );

  @override
  Future<List<Order>> ordersForCustomer(String customerId) => _query(
    where: '${OrderTable.customerId} = ?',
    whereArgs: [customerId],
  );

  @override
  Future<Order?> findByReference(String reference) async {
    final orders = await _query(
      where: '${OrderTable.reference} = ?',
      whereArgs: [reference],
    );

    return orders.firstOrNull;
  }

  Future<List<Order>> _query({
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final orderRows = await _db.query(
      OrderTable.name,
      where: where,
      whereArgs: whereArgs,
      orderBy: '${OrderTable.placedAt} DESC',
    );

    if (orderRows.isEmpty) return const [];

    final references = orderRows
        .map((row) => row[OrderTable.reference] as String)
        .toList();
    final placeholders = List.filled(references.length, '?').join(', ');

    final lineRows = await _db.query(
      OrderLineTable.name,
      where: '${OrderLineTable.orderReference} IN ($placeholders)',
      whereArgs: references,
    );

    final linesByReference = <String, List<OrderLineItem>>{};
    for (final row in lineRows) {
      linesByReference
          .putIfAbsent(row[OrderLineTable.orderReference] as String, () => [])
          .add(_lineFrom(row));
    }

    return [
      for (final row in orderRows)
        _orderFrom(row, linesByReference[row[OrderTable.reference]] ?? const []),
    ];
  }

  Map<String, Object?> _orderRow(Order order) => {
    OrderTable.reference: order.reference,
    OrderTable.customerId: order.customerId,
    OrderTable.customerName: order.customerName,
    OrderTable.placedAt: order.placedAt.millisecondsSinceEpoch,
    OrderTable.status: order.status.name,
  };

  Map<String, Object?> _lineRow(String reference, OrderLineItem line) => {
    OrderLineTable.orderReference: reference,
    OrderLineTable.productId: line.productId,
    OrderLineTable.productName: line.productName,
    OrderLineTable.unitPrice: line.unitPrice,
    OrderLineTable.quantity: line.quantity,
  };

  Order _orderFrom(Map<String, Object?> row, List<OrderLineItem> lines) => Order(
    reference: row[OrderTable.reference]! as String,
    customerId: row[OrderTable.customerId]! as String,
    customerName: row[OrderTable.customerName]! as String,
    placedAt: DateTime.fromMillisecondsSinceEpoch(
      row[OrderTable.placedAt]! as int,
    ),
    status: OrderStatus.values.byName(row[OrderTable.status]! as String),
    lines: lines,
  );

  OrderLineItem _lineFrom(Map<String, Object?> row) => OrderLineItem(
    productId: row[OrderLineTable.productId]! as String,
    productName: row[OrderLineTable.productName]! as String,
    unitPrice: row[OrderLineTable.unitPrice]! as double,
    quantity: row[OrderLineTable.quantity]! as int,
  );
}
