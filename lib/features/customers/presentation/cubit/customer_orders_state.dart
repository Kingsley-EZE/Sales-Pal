part of 'customer_orders_cubit.dart';

sealed class CustomerOrdersState extends Equatable {
  const CustomerOrdersState();

  @override
  List<Object?> get props => [];
}

final class CustomerOrdersLoading extends CustomerOrdersState {
  const CustomerOrdersLoading();
}

final class CustomerOrdersLoaded extends CustomerOrdersState {
  const CustomerOrdersLoaded(this.orders);

  final List<Order> orders;

  @override
  List<Object?> get props => [orders];
}

final class CustomerOrdersFailed extends CustomerOrdersState {
  const CustomerOrdersFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
