import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' hide Order;

import '../../../../core/error/failure.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_line_item.dart';
import '../../domain/repositories/order_repository.dart';

part 'submit_order_state.dart';


@singleton
class SubmitOrderCubit extends Cubit<SubmitOrderState> {
  SubmitOrderCubit(this._repository) : super(const SubmitOrderIdle());

  final OrderRepository _repository;

  static final _random = Random();

  Future<void> submit({
    required String customerId,
    required String customerName,
    required List<OrderLineItem> lines,
  }) => _triggerSubmitOrder(
    Order(
      reference: newReference(),
      customerId: customerId,
      customerName: customerName,
      placedAt: DateTime.now(),
      status: OrderStatus.pending,
      lines: lines,
    ),
  );

  Future<void> retry() async {
    if (state case SubmitOrderFailed(:final order)) await _triggerSubmitOrder(order);
  }

  Future<void> saveAsPending() async {
    if (state case SubmitOrderFailed(:final order, :final failure)) {
      final result = await _repository.saveAsPending(order);

      emit(
        result.fold(
          (saveFailure) => SubmitOrderFailed(order, saveFailure),
          (_) => SubmitOrderFailed(order, failure),
        ),
      );
    }
  }

  void reset() => emit(const SubmitOrderIdle());

  static String newReference() =>
      'FF-${DateTime.now().year}-${_random.nextInt(9000) + 1000}';

  Future<void> _triggerSubmitOrder(Order order) async {
    emit(const SubmitOrderInProgress());

    final result = await _repository.submit(order);

    emit(
      result.fold(
        (failure) => SubmitOrderFailed(order, failure),
        SubmitOrderSucceeded.new,
      ),
    );
  }
}
