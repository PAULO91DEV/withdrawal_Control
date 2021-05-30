import 'package:controleRetirada/data/datasources/activation/activation_datasource.dart';
import 'package:controleRetirada/domain/entities/activation_entity.dart';

class ActivationMockDataSource implements ActivationDataSource {
  @override
  Future<ActivationEntity> getLocalByActivationCode(
    String tokenAPI,
    String activateCode,
  ) {
    return Future.delayed(Duration(seconds: 3)).then((value) {
      var jsonData = '{"macAddress":"01:02:03:04:05:07","activateCode":"asd"}';
      return activationEntityFromJson(jsonData);
    });
  }
}
