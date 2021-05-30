import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/core/usecase.dart';
import 'package:controleRetirada/domain/repositories/cart_repository.dart';

class GetAllItemsCartUseCase implements UseCase<List<ItemValue>, NoParams> {
  final CartRepository _repository;
  GetAllItemsCartUseCase(this._repository);

  @override
  Future<List<ItemValue>> call(NoParams params) {
    return this._repository.getAll();
  }
}
