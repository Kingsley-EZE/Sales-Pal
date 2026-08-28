import 'package:equatable/equatable.dart';


class Customer extends Equatable {
  const Customer({
    required this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
    this.amountDue = 0,
  });

  final String id;
  final String name;
  final String location;
  final String phoneNumber;
  final double amountDue;

  bool get hasOutstandingBalance => amountDue > 0;

  bool matches(String query) {
    final term = query.trim().toLowerCase();

    return name.toLowerCase().contains(term) ||
        location.toLowerCase().contains(term);
  }

  @override
  List<Object?> get props => [id, name, location, phoneNumber, amountDue];
}
