import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' hide Order;

import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

part 'order_queue_state.dart';

@injectable
class OrderQueueCubit extends Cubit<OrderQueueState> {
  OrderQueueCubit(this._repository) : super(const OrderQueueLoading()) {
    _changes = _repository.changes.listen((_) => load());
  }

  final OrderRepository _repository;
  late final StreamSubscription<void> _changes;

  @override
  Future<void> close() async {
    await _changes.cancel();

    return super.close();
  }

  Future<void> load() async {
    final current = state;
    if (current is! OrderQueueLoaded) emit(const OrderQueueLoading());

    final results = await Future.wait([
      _repository.ordersByStatus(OrderStatus.pending),
      _repository.ordersByStatus(OrderStatus.submitted),
    ]);

    if (isClosed) return;

    final pending = results.first.fold((_) => null, (orders) => orders);
    final submitted = results.last.fold((_) => null, (orders) => orders);

    if (pending == null || submitted == null) {
      emit(const OrderQueueFailed('Could not load your orders.'));
      return;
    }

    emit(
      OrderQueueLoaded(
        pending: pending,
        submitted: submitted,
        tab: current is OrderQueueLoaded ? current.tab : OrderQueueTab.pending,
        expandedReference: current is OrderQueueLoaded
            ? current.expandedReference
            : null,
      ),
    );
  }

  void selectTab(OrderQueueTab tab) {
    if (state case final OrderQueueLoaded current when current.tab != tab) {
      emit(
        OrderQueueLoaded(
          pending: current.pending,
          submitted: current.submitted,
          tab: tab,
          retryingReference: current.retryingReference,
        ),
      );
    }
  }

  void toggleExpanded(Order order) {
    if (state case final OrderQueueLoaded current) {
      emit(
        OrderQueueLoaded(
          pending: current.pending,
          submitted: current.submitted,
          tab: current.tab,
          expandedReference: current.isExpanded(order) ? null : order.reference,
          retryingReference: current.retryingReference,
        ),
      );
    }
  }


  Future<void> retry(Order order) async {
    if (state case final OrderQueueLoaded current) {
      emit(
        OrderQueueLoaded(
          pending: current.pending,
          submitted: current.submitted,
          tab: current.tab,
          expandedReference: current.expandedReference,
          retryingReference: order.reference,
        ),
      );

      final result = await _repository.submit(order);
      if (isClosed) return;

      final failure = result.fold((failure) => failure.message, (_) => null);

      await load();

      if (state case final OrderQueueLoaded latest when failure != null) {
        emit(
          OrderQueueLoaded(
            pending: latest.pending,
            submitted: latest.submitted,
            tab: latest.tab,
            expandedReference: latest.expandedReference,
            retryFailureMessage: failure,
          ),
        );
      }
    }
  }

  void clearRetryFailure() {
    if (state case final OrderQueueLoaded current
        when current.retryFailureMessage != null) {
      emit(
        OrderQueueLoaded(
          pending: current.pending,
          submitted: current.submitted,
          tab: current.tab,
          expandedReference: current.expandedReference,
          retryingReference: current.retryingReference,
        ),
      );
    }
  }
}
