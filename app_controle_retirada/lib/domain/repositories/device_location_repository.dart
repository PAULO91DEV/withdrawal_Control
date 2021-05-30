import 'package:controleRetirada/domain/entities/device_location_entity.dart';

class DeviceLocationRepository {
  // ignore: missing_return
  Future<DeviceLocationEntity> postDeviceLocalByDeviceCode(
    String tokenAPI,
    String macAddress,
    String activateCode,
  ) {}
  // ignore: missing_return
  Future<void> deviceOnLocation(
    String token,
    String macAddress,
    String activationCode,
  ) {}
}
