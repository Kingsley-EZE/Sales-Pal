import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

abstract final class OrderTable {
  static const name = 'orders';

  static const reference = 'reference';
  static const customerId = 'customer_id';
  static const customerName = 'customer_name';
  static const placedAt = 'placed_at';
  static const status = 'status';
}

abstract final class OrderLineTable {
  static const name = 'order_lines';

  static const orderReference = 'order_reference';
  static const productId = 'product_id';
  static const productName = 'product_name';
  static const unitPrice = 'unit_price';
  static const quantity = 'quantity';
}

abstract final class AppDatabase {
  static const fileName = 'sales_pal.db';
  static const _version = 1;
  static const seedAsset = 'assets/data/orders.json';

  static String? pathOverride;

  static Future<Database> open() async => openDatabase(
    pathOverride ?? p.join(await getDatabasesPath(), fileName),
    version: _version,
    onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    onCreate: (db, _) async {
      await createSchema(db);
      await seed(db, await _readSeed());
    },
  );

  static Future<void> createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE ${OrderTable.name} (
        ${OrderTable.reference} TEXT PRIMARY KEY,
        ${OrderTable.customerId} TEXT NOT NULL,
        ${OrderTable.customerName} TEXT NOT NULL,
        ${OrderTable.placedAt} INTEGER NOT NULL,
        ${OrderTable.status} TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${OrderLineTable.name} (
        ${OrderLineTable.orderReference} TEXT NOT NULL,
        ${OrderLineTable.productId} TEXT NOT NULL,
        ${OrderLineTable.productName} TEXT NOT NULL,
        ${OrderLineTable.unitPrice} REAL NOT NULL,
        ${OrderLineTable.quantity} INTEGER NOT NULL,
        PRIMARY KEY (
          ${OrderLineTable.orderReference},
          ${OrderLineTable.productId}
        ),
        FOREIGN KEY (${OrderLineTable.orderReference})
          REFERENCES ${OrderTable.name} (${OrderTable.reference})
          ON DELETE CASCADE
      )
    ''');
  }

  static Future<void> seed(Database db, List<Map<String, dynamic>> orders) =>
      db.transaction((txn) async {
        for (final order in orders) {
          final lines = (order['lines'] as List<dynamic>)
              .cast<Map<String, dynamic>>();

          await txn.insert(OrderTable.name, {
            OrderTable.reference: order['reference'],
            OrderTable.customerId: order['customerId'],
            OrderTable.customerName: order['customerName'],
            OrderTable.placedAt: DateTime.parse(
              order['placedAt'] as String,
            ).millisecondsSinceEpoch,
            OrderTable.status: order['status'],
          });

          for (final line in lines) {
            await txn.insert(OrderLineTable.name, {
              OrderLineTable.orderReference: order['reference'],
              OrderLineTable.productId: line['productId'],
              OrderLineTable.productName: line['productName'],
              OrderLineTable.unitPrice: line['unitPrice'],
              OrderLineTable.quantity: line['quantity'],
            });
          }
        }
      });

  static Future<List<Map<String, dynamic>>> _readSeed() async {
    final raw = await rootBundle.loadString(seedAsset);

    return (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
  }
}

@module
abstract class DatabaseModule {
  @preResolve
  @lazySingleton
  Future<Database> get database => AppDatabase.open();
}
