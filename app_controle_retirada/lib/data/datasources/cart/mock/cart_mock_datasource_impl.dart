import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/data/datasources/cart/cart_datasource.dart';

class CartMockDataSourceImpl implements CartDataSource {
  @override
  Future<void> add(ItemValue item) {
    throw UnimplementedError();
  }

  @override
  Future<void> clear() {
    throw UnimplementedError();
  }

  @override
  Future<List<ItemValue>> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<void> remove(ItemValue item) {
    throw UnimplementedError();
  }
}
