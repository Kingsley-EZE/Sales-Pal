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
  const CustomersLoaded({required this.all, this.query = ''});

  final List<Customer> all;
  final String query;

  List<Customer> get visible => query.trim().isEmpty
      ? all
      : all.where((customer) => customer.matches(query)).toList();

  bool get hasNoMatches => visible.isEmpty && all.isNotEmpty;

  CustomersLoaded copyWith({String? query}) =>
      CustomersLoaded(all: all, query: query ?? this.query);

  @override
  List<Object?> get props => [all, query];
}

final class CustomersFailed extends CustomersState {
  const CustomersFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
