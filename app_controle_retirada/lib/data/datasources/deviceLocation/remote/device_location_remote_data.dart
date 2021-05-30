import 'package:dio/dio.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/deviceLocation/device_location_datasource.dart';
import 'package:controleRetirada/domain/entities/device_location_entity.dart';

class DeviceRemoteDataSource implements DeviceLocationDataSource {
  final Dio _dio;
  DeviceRemoteDataSource(this._dio);

  Future<DeviceLocationEntity> postDeviceLocalByDeviceCode(
    String tokenAPI,
    String macAddress,
    String activateCode,
  ) {
    return this._dio.post(
      "$kUrlActivate",
      options: Options(
        headers: {
          'token': tokenAPI,
        },
      ),
      data: {
        "macAddress": macAddress,
        "activateCode": activateCode,
      },
    ).then((result) {
      if (result.statusCode == 201) {
        return DeviceLocationEntity.fromJson(result.data);
      }
      throw Exception(
          "Ops! Houve um problema em nossos servidores, tente mais tarde!");
    });
  }
}
