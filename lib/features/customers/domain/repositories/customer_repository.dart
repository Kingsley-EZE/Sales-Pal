import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/customer.dart';

abstract interface class CustomerRepository {
  Future<Either<Failure, List<Customer>>> getCustomers();

  Future<Either<Failure, Customer?>> getCustomer(String id);
}
