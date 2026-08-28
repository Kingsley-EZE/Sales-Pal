import 'package:dartz/dartz.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../entities/order.dart';

abstract interface class OrderRepository {
  Stream<void> get changes;

  Future<Either<Failure, Order>> submit(Order order);

  Future<Either<Failure, Order>> saveAsPending(Order order);

  Future<Either<Failure, List<Order>>> ordersByStatus(OrderStatus status);

  Future<Either<Failure, List<Order>>> ordersForCustomer(String customerId);
}
