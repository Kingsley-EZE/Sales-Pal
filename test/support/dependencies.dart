import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales_pal/core/data/app_database.dart';
import 'package:sales_pal/core/data/json_asset_loader.dart';
import 'package:sales_pal/core/di/injection.dart';
import 'package:sales_pal/features/orders/data/datasources/order_api_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void useTestDependencies() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    AppDatabase.pathOverride = inMemoryDatabasePath;
  });

  setUp(() async {
    JsonAssetLoader.latency = Duration.zero;
    OrderApiService.latency = Duration.zero;
    rootBundle.clear();

    await getIt.reset();
    await configureDependencies();
  });
}
