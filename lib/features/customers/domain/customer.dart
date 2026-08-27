class Customer {
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
}
