import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/core/exceptions.dart';
import 'package:controleRetirada/core/usecase.dart';

import 'package:controleRetirada/domain/repositories/cart_repository.dart';

class AddItemCardUseCase implements UseCase<void, AddItemCartUseCaseParam> {
  final CartRepository _repository;
  AddItemCardUseCase(this._repository);
  List<ItemValue> _items;

  @override
  Future<void> call(AddItemCartUseCaseParam params) async {
    this._items = await _repository.getAll();
    //if (params.item.isNotEmpty /*is ProductEntity */) {
    return _addProductEntityToCart(params.item);
    // }
  }

  Future _addProductEntityToCart(dynamic itemValue) {
    var itemsExist = this
        ._items
        .where(
          (e) => e.value["product_id"] == itemValue.productId,
        )
        .toList();
    return this._addItemToCart(
      itemValue.qtyRemaining,
      itemValue.existsItem,
      itemValue.automaticDown,
      itemsExist.length,
      itemValue.productDescription,
      itemValue.partDescription,
      itemValue.codeReturn,
      itemValue,
    );
  }

  Future _addItemToCart(
    int qtyRemaining,
    int existsItem,
    int automaticDown,
    int sameItemAmount,
    String label,
    String description,
    int returnCode,
    dynamic value,
  ) {
    if (returnCode != 0) {
      throw DisplayReturnMessage();
    }

    if (existsItem > 0) {
      throw ForSelectionOnlyException();
    }

    // Verifica o saldo
    if (value.itemId.isNotEmpty) {
      var itemsIdExist = this
          ._items
          .where(
            (e) => e.value["item_id"] == value.itemId,
          )
          .toList();
      if (qtyRemaining - (itemsIdExist.length + 1) < 0) {
        throw InsufficientFundsException();
      }
    } else if ((qtyRemaining - (sameItemAmount + 1)) < 0) {
      throw InsufficientFundsException();
    }

    return this
        ._repository
        .add(ItemValue(label: label, detail: description, value: value));
  }
}

class AddItemCartUseCaseParam {
  final dynamic item;

  AddItemCartUseCaseParam(this.item);
}
