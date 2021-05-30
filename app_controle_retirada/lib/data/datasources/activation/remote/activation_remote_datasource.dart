import 'package:dio/dio.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/activation/activation_datasource.dart';

import 'package:controleRetirada/domain/entities/activation_entity.dart';

class ActivationRemoteDatasource implements ActivationDataSource {
  final Dio _dio;
  ActivationRemoteDatasource(this._dio);

  @override
  Future<ActivationEntity> getLocalByActivationCode(
    String tokenAPI,
    String activateCode,
  ) {
    return this
        ._dio
        .get(
          '$kUrlActivate/$activateCode',
          options: Options(
            headers: {
              'token': tokenAPI,
            },
          ),
        )
        .then((value) {
      ActivationEntity response = ActivationEntity.fromJson(value.data);

      return response;
    });
  }
}
