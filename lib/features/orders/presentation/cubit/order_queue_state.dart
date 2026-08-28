part of 'order_queue_cubit.dart';

enum OrderQueueTab { pending, submitted }

sealed class OrderQueueState extends Equatable {
  const OrderQueueState();

  @override
  List<Object?> get props => [];
}

final class OrderQueueLoading extends OrderQueueState {
  const OrderQueueLoading();
}

final class OrderQueueFailed extends OrderQueueState {
  const OrderQueueFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class OrderQueueLoaded extends OrderQueueState {
  const OrderQueueLoaded({
    required this.pending,
    required this.submitted,
    this.tab = OrderQueueTab.pending,
    this.expandedReference,
    this.retryingReference,
    this.retryFailureMessage,
  });

  final List<Order> pending;
  final List<Order> submitted;
  final OrderQueueTab tab;

  final String? expandedReference;
  final String? retryingReference;
  final String? retryFailureMessage;

  List<Order> get visible => switch (tab) {
    OrderQueueTab.pending => pending,
    OrderQueueTab.submitted => submitted,
  };

  bool isExpanded(Order order) => order.reference == expandedReference;

  bool isRetrying(Order order) => order.reference == retryingReference;

  @override
  List<Object?> get props => [
    pending,
    submitted,
    tab,
    expandedReference,
    retryingReference,
    retryFailureMessage,
  ];
}
