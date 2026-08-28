import 'package:equatable/equatable.dart';


class CustomerDto extends Equatable {
  const CustomerDto({
    required this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.amountDue,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) => CustomerDto(
    id: json['id'] as String,
    name: json['name'] as String,
    location: json['location'] as String,
    phoneNumber: json['phoneNumber'] as String,
    amountDue: (json['amountDue'] as num).toDouble(),
  );

  final String id;
  final String name;
  final String location;
  final String phoneNumber;
  final double amountDue;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'phoneNumber': phoneNumber,
    'amountDue': amountDue,
  };

  @override
  List<Object?> get props => [id, name, location, phoneNumber, amountDue];
}
