import 'package:controleRetirada/data/datasources/deviceLocation/device_location_datasource.dart';
import 'package:controleRetirada/domain/entities/device_location_entity.dart';
import 'package:controleRetirada/domain/repositories/device_location_repository.dart';

class DeviceLocationRepositoryImpl implements DeviceLocationRepository {
  final DeviceLocationDataSource _dataSource;
  DeviceLocationRepositoryImpl(this._dataSource);

  @override
  Future<DeviceLocationEntity> postDeviceLocalByDeviceCode(
    String tokenAPI,
    String macAddress,
    String activateCode,
  ) {
    return this._dataSource.postDeviceLocalByDeviceCode(
          tokenAPI,
          macAddress,
          activateCode,
        );
  }

  @override
  Future<void> deviceOnLocation(
    String token,
    String macAddress,
    String activationCode,
  ) {
    throw UnimplementedError();
  }
}
