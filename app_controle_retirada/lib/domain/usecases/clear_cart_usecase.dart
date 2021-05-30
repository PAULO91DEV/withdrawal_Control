import 'package:controleRetirada/core/usecase.dart';
import 'package:controleRetirada/domain/repositories/cart_repository.dart';

class ClearCartUseCase implements UseCase<void, NoParams> {
  final CartRepository _repository;
  ClearCartUseCase(this._repository);

  @override
  Future<void> call(NoParams params) {
    return this._repository.clear();
  }
}
