import 'package:dartz/dartz.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_api_service.dart';
import '../datasources/order_local_data_source.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this._api, this._local);

  final OrderApiService _api;
  final OrderLocalDataSource _local;

  @override
  Future<Either<Failure, Order>> submit(Order order) async {
    try {
      await _api.submit(order);
    } on OfflineException {
      return const Left(OfflineFailure());
    } catch (_) {
      return const Left(DataFailure('Could not submit this order.'));
    }

    final submitted = order.copyWith(status: OrderStatus.submitted);

    try {
      await _local.save(submitted);
    } catch (_) {

    }

    return Right(submitted);
  }

  @override
  Future<Either<Failure, Order>> saveAsPending(Order order) async {
    final pending = order.copyWith(status: OrderStatus.pending);

    try {
      await _local.save(pending);
      return Right(pending);
    } catch (_) {
      return const Left(DataFailure('Could not save this order.'));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> ordersByStatus(OrderStatus status) =>
      _read(() => _local.ordersByStatus(status));

  @override
  Future<Either<Failure, List<Order>>> ordersForCustomer(String customerId) =>
      _read(() => _local.ordersForCustomer(customerId));

  Future<Either<Failure, List<Order>>> _read(
    Future<List<Order>> Function() query,
  ) async {
    try {
      return Right(await query());
    } catch (_) {
      return const Left(DataFailure('Could not load orders.'));
    }
  }
}
