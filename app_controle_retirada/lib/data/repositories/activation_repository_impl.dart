import 'package:controleRetirada/data/datasources/activation/activation_datasource.dart';
import 'package:controleRetirada/domain/entities/activation_entity.dart';
import 'package:controleRetirada/domain/repositories/activation_repository.dart';

class ActivationRepositoryImpl implements ActivationRepository {
  final ActivationDataSource _dataSource;
  ActivationRepositoryImpl(this._dataSource);

  @override
  Future<ActivationEntity> getLocalByActivationCode(
    String tokenAPI,
    String activateCode,
  ) {
    return this._dataSource.getLocalByActivationCode(
          tokenAPI,
          activateCode,
        );
  }

  @override
  Future<void> registerDeviceOnLocation(
      String token, String activationCode, String macAddress) {
    throw UnimplementedError();
  }
}
