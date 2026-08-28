import '../../domain/entities/customer.dart';
import '../dtos/customer_dto.dart';


extension CustomerDtoMapper on CustomerDto {
  Customer toEntity() => Customer(
    id: id,
    name: name,
    location: location,
    phoneNumber: phoneNumber,
    amountDue: amountDue,
  );
}

extension CustomerDtoListMapper on List<CustomerDto> {
  List<Customer> toEntities() => map((dto) => dto.toEntity()).toList();
}
