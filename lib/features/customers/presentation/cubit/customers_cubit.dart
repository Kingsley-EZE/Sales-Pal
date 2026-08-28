import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

part 'customers_state.dart';

@injectable
class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(this._repository) : super(const CustomersLoading());

  final CustomerRepository _repository;

  Future<void> load() async {
    emit(const CustomersLoading());

    final result = await _repository.getCustomers();

    emit(
      result.fold(
        (failure) => CustomersFailed(failure.message),
        (customers) => CustomersLoaded(all: customers),
      ),
    );
  }

  void search(String query) {
    final current = state;
    if (current is! CustomersLoaded) return;

    emit(current.copyWith(query: query));
  }
}
