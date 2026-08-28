import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_local_data_source.dart';
import '../mappers/customer_mapper.dart';

@LazySingleton(as: CustomerRepository)
class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._dataSource);

  final CustomerLocalDataSource _dataSource;

  @override
  Future<Either<Failure, List<Customer>>> getCustomers() async {
    try {
      final dtos = await _dataSource.fetchCustomers();
      return Right(dtos.toEntities());
    } catch (_) {
      return const Left(DataFailure('Could not load customers.'));
    }
  }

  @override
  Future<Either<Failure, Customer?>> getCustomer(String id) async {
    final result = await getCustomers();
    return result.map(
      (customers) => customers.where((customer) => customer.id == id).firstOrNull,
    );
  }
}
