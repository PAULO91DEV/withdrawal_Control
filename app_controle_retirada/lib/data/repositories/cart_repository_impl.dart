import 'dart:async';

import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/data/datasources/cart/cart_datasource.dart';
import 'package:controleRetirada/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDataSource _dataSource;
  CartRepositoryImpl(this._dataSource);

  @override
  Future<void> add(ItemValue item) {
    return this._dataSource.add(item);
  }

  @override
  FutureOr<void> clear() {
    return this._dataSource.clear();
  }

  @override
  Future<List<ItemValue>> getAll() {
    return this._dataSource.getAll();
  }

  @override
  FutureOr<void> remove(ItemValue item) {
    return this._dataSource.remove(item);
  }
}
