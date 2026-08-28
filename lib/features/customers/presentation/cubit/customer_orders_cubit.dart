import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' hide Order;

import '../../../orders/domain/entities/order.dart';
import '../../../orders/domain/repositories/order_repository.dart';

part 'customer_orders_state.dart';

@injectable
class CustomerOrdersCubit extends Cubit<CustomerOrdersState> {
  CustomerOrdersCubit(this._repository) : super(const CustomerOrdersLoading());

  final OrderRepository _repository;

  String? _customerId;
  StreamSubscription<void>? _changes;

  @override
  Future<void> close() async {
    await _changes?.cancel();

    return super.close();
  }

  Future<void> load(String customerId) async {
    _customerId = customerId;
    _changes ??= _repository.changes.listen((_) => _reload());

    await _reload();
  }

  Future<void> _reload() async {
    if (_customerId case final customerId?) {
      final result = await _repository.ordersForCustomer(customerId);

      if (isClosed) return;

      emit(
        result.fold(
          (failure) => CustomerOrdersFailed(failure.message),
          CustomerOrdersLoaded.new,
        ),
      );
    }
  }
}
