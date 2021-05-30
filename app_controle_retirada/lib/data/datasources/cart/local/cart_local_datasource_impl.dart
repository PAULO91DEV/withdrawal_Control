import 'dart:async';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/data/datasources/cart/cart_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSourceImpl implements CartDataSource {
  SharedPreferences _prefs;

  @override
  Future<void> add(ItemValue item) async {
    return this.getAll().then((items) {
      items.add(item);
      this._prefs.setString(kSharedPrefsCardItems, itemValueToJson(items));
    });
  }

  @override
  FutureOr<void> clear() {
    _loadSharedPrefences().then((_) {
      this._prefs.remove(kSharedPrefsCardItems);
    });
  }

  @override
  Future<List<ItemValue>> getAll() {
    return _loadSharedPrefences().then((_) {
      List<ItemValue> items;
      String jsonValue = this._prefs.getString(kSharedPrefsCardItems);
      if (jsonValue != null && jsonValue.isNotEmpty) {
        items = itemValueFromJson(jsonValue);
      } else {
        items = [];
      }
      return items;
    });
  }

  @override
  FutureOr<void> remove(ItemValue item) async {
    return this._loadSharedPrefences().then((_) {
      return this.getAll();
    }).then((cartItems) {
      cartItems.removeWhere((e) =>
          e.value["product_id"] == item.value["product_id"] &&
          e.value["item_id"] == item.value["item_id"]);
      this._prefs.setString(kSharedPrefsCardItems, itemValueToJson(cartItems));
    });
  }

  Future<void> _loadSharedPrefences() async {
    if (this._prefs == null) {
      this._prefs = await SharedPreferences.getInstance();
    }
  }
}
