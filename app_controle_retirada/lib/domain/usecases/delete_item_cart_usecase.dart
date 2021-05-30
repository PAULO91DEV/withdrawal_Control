import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/core/usecase.dart';
import 'package:controleRetirada/domain/repositories/cart_repository.dart';

class DeleteItemCartUseCase
    implements UseCase<void, DeleteItemCartUseCaseParams> {
  final CartRepository _repository;
  DeleteItemCartUseCase(this._repository);

  @override
  Future<void> call(DeleteItemCartUseCaseParams params) {
    return this._repository.remove(params._itemValue);
  }
}

class DeleteItemCartUseCaseParams {
  final ItemValue _itemValue;
  DeleteItemCartUseCaseParams(this._itemValue);
}
