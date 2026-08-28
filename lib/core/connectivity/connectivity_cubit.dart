import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'connectivity_monitor.dart';


@singleton
class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit(this._monitor) : super(true);

  final ConnectivityMonitor _monitor;
  StreamSubscription<bool>? _subscription;

  bool get isOnline => state;

  Future<void> watch() async {
    _subscription ??= _monitor.onConnectionChanged.listen(_set);

    _set(await _monitor.hasConnection);
  }

  @visibleForTesting
  void setOnline({required bool isOnline}) => _set(isOnline);

  @override
  Future<void> close() async {
    await _subscription?.cancel();

    return super.close();
  }

  void _set(bool isOnline) {
    if (!isClosed) emit(isOnline);
  }
}
