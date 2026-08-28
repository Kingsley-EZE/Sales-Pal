import 'dart:async';

import 'package:sales_pal/core/connectivity/connectivity_monitor.dart';

class FakeConnectivityMonitor implements ConnectivityMonitor {
  FakeConnectivityMonitor({this.isConnected = true});

  bool isConnected;

  final _controller = StreamController<bool>.broadcast();

  @override
  Future<bool> get hasConnection async => isConnected;

  @override
  Stream<bool> get onConnectionChanged => _controller.stream;

  void emit({required bool isConnected}) {
    this.isConnected = isConnected;
    _controller.add(isConnected);
  }

  Future<void> dispose() => _controller.close();
}
