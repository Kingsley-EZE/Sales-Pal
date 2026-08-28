import 'dart:async';

import 'package:dartz/dartz.dart' hide Order;
import 'package:sales_pal/core/error/failure.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/orders/domain/repositories/order_repository.dart';

class FakeOrderRepository implements OrderRepository {
  Failure? submitFailure;
  Failure? saveFailure;
  Failure? readFailure;

  /// What the queries answer with, so a test can stock the queue.
  List<Order> stored = const [];

  final submitted = <Order>[];
  final saved = <Order>[];

  final _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  Future<void> dispose() => _changes.close();

  @override
  Future<Either<Failure, Order>> submit(Order order) async {
    submitted.add(order);

    if (submitFailure case final failure?) return Left(failure);

    final result = order.copyWith(status: OrderStatus.submitted);
    _replace(result);

    return Right(result);
  }

  @override
  Future<Either<Failure, Order>> saveAsPending(Order order) async {
    saved.add(order);

    if (saveFailure case final failure?) return Left(failure);

    final result = order.copyWith(status: OrderStatus.pending);
    _replace(result);

    return Right(result);
  }

  @override
  Future<Either<Failure, List<Order>>> ordersByStatus(
    OrderStatus status,
  ) async {
    if (readFailure case final failure?) return Left(failure);

    return Right(stored.where((order) => order.status == status).toList());
  }

  @override
  Future<Either<Failure, List<Order>>> ordersForCustomer(
    String customerId,
  ) async {
    if (readFailure case final failure?) return Left(failure);

    return Right(
      stored.where((order) => order.customerId == customerId).toList(),
    );
  }

  /// Mirrors the real repository: a write lands in the store and wakes anyone
  /// listing orders.
  void _replace(Order order) {
    stored = [
      for (final existing in stored)
        if (existing.reference != order.reference) existing,
      order,
    ];
    _changes.add(null);
  }
}
