part of 'submit_order_cubit.dart';

sealed class SubmitOrderState extends Equatable {
  const SubmitOrderState();

  @override
  List<Object?> get props => [];
}

final class SubmitOrderIdle extends SubmitOrderState {
  const SubmitOrderIdle();
}

final class SubmitOrderInProgress extends SubmitOrderState {
  const SubmitOrderInProgress();
}

final class SubmitOrderSucceeded extends SubmitOrderState {
  const SubmitOrderSucceeded(this.order);

  final Order order;

  @override
  List<Object?> get props => [order];
}

final class SubmitOrderFailed extends SubmitOrderState {
  const SubmitOrderFailed(this.order, this.failure);

  final Order order;
  final Failure failure;

  @override
  List<Object?> get props => [order, failure];
}
