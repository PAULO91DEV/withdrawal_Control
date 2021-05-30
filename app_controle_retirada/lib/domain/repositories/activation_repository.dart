// Nesse contratato iremos passar o codigo e o DNA do device para a API.
import 'package:controleRetirada/domain/entities/activation_entity.dart';

class ActivationRepository {
  // ignore: missing_return
  Future<ActivationEntity> getLocalByActivationCode(
    String tokenAPI,
    String activateCode,
  ) {}

  // ignore: missing_return
  Future<void> registerDeviceOnLocation(
    String token,
    String activationCode,
    String macAddress,
  ) {}
}
