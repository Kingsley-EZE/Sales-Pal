import 'package:injectable/injectable.dart';

import '../../../../core/data/json_asset_loader.dart';
import '../dtos/customer_dto.dart';

abstract interface class CustomerLocalDataSource {
  Future<List<CustomerDto>> fetchCustomers();
}


@LazySingleton(as: CustomerLocalDataSource)
class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  const CustomerLocalDataSourceImpl(this._loader);

  static const _assetPath = 'assets/data/customers.json';

  final JsonAssetLoader _loader;

  @override
  Future<List<CustomerDto>> fetchCustomers() async {
    final rows = await _loader.loadList(_assetPath);
    return rows.map(CustomerDto.fromJson).toList();
  }
}
