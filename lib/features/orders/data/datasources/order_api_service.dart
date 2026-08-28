import 'package:injectable/injectable.dart' hide Order;

import '../../../../core/connectivity/connectivity_cubit.dart';
import '../../domain/entities/order.dart';

class OfflineException implements Exception {
  const OfflineException();
}

@lazySingleton
class OrderApiService {
  const OrderApiService(this._connectivity);

  final ConnectivityCubit _connectivity;

  static Duration latency = const Duration(milliseconds: 1200);

  Future<void> submit(Order order) async {
    await Future<void>.delayed(latency);

    if (!_connectivity.isOnline) throw const OfflineException();
  }
}
