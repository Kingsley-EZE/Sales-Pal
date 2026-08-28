import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/connectivity/connectivity_cubit.dart';

import '../../support/fake_connectivity_monitor.dart';

void main() {
  late FakeConnectivityMonitor monitor;
  late ConnectivityCubit cubit;

  setUp(() {
    monitor = FakeConnectivityMonitor();
    cubit = ConnectivityCubit(monitor);
  });

  tearDown(() async {
    await cubit.close();
    await monitor.dispose();
  });

  test('starts optimistic so the first frame does not flash offline', () {
    expect(cubit.isOnline, isTrue);
  });

  test('takes its state from the first check', () async {
    monitor.isConnected = false;

    await cubit.watch();

    expect(cubit.isOnline, isFalse);
  });

  test('follows the connection as it changes', () async {
    await cubit.watch();

    monitor.emit(isConnected: false);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.isOnline, isFalse);

    monitor.emit(isConnected: true);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.isOnline, isTrue);
  });

  test('watching twice keeps a single subscription', () async {
    await cubit.watch();
    await cubit.watch();

    var emissions = 0;
    final subscription = cubit.stream.listen((_) => emissions++);

    monitor.emit(isConnected: false);
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(emissions, 1);
  });

  test('a check landing after close is ignored', () async {
    await cubit.watch();
    await cubit.close();

    expect(() => monitor.emit(isConnected: false), returnsNormally);
  });
}
