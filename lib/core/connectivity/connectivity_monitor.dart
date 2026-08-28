import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


abstract interface class ConnectivityMonitor {
  Future<bool> get hasConnection;
  Stream<bool> get onConnectionChanged;
}

@LazySingleton(as: ConnectivityMonitor)
class InternetConnectionMonitor implements ConnectivityMonitor {
  InternetConnectionMonitor() : _connection = InternetConnection();

  final InternetConnection _connection;

  @override
  Future<bool> get hasConnection => _connection.hasInternetAccess;

  @override
  Stream<bool> get onConnectionChanged => _connection.onStatusChange.map(
    (status) => status == InternetStatus.connected,
  );
}
