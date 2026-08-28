import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class DataFailure extends Failure {
  const DataFailure([super.message = 'Something went wrong. Please try again.']);
}


final class OfflineFailure extends Failure {
  const OfflineFailure([
    super.message =
        'It seems you are currently offline or experiencing weak internet '
            'connectivity.',
  ]);
}
