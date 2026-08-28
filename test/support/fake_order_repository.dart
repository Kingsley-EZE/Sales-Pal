import 'package:dartz/dartz.dart' hide Order;
import 'package:sales_pal/core/error/failure.dart';
import 'package:sales_pal/features/orders/domain/entities/order.dart';
import 'package:sales_pal/features/orders/domain/repositories/order_repository.dart';

class FakeOrderRepository implements OrderRepository {
  Failure? submitFailure;
  Failure? saveFailure;

  final submitted = <Order>[];
  final saved = <Order>[];

  @override
  Future<Either<Failure, Order>> submit(Order order) async {
    submitted.add(order);

    if (submitFailure case final failure?) return Left(failure);

    return Right(order.copyWith(status: OrderStatus.submitted));
  }

  @override
  Future<Either<Failure, Order>> saveAsPending(Order order) async {
    saved.add(order);

    if (saveFailure case final failure?) return Left(failure);

    return Right(order.copyWith(status: OrderStatus.pending));
  }

  @override
  Future<Either<Failure, List<Order>>> ordersByStatus(
    OrderStatus status,
  ) async => const Right([]);

  @override
  Future<Either<Failure, List<Order>>> ordersForCustomer(
    String customerId,
  ) async => const Right([]);
}
