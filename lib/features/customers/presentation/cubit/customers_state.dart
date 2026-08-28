part of 'customers_cubit.dart';

sealed class CustomersState extends Equatable {
  const CustomersState();

  @override
  List<Object?> get props => [];
}

final class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

final class CustomersLoaded extends CustomersState {
  const CustomersLoaded(this.customers);

  final List<Customer> customers;

  @override
  List<Object?> get props => [customers];
}

final class CustomersFailed extends CustomersState {
  const CustomersFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
