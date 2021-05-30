import 'package:dio/dio.dart';
import 'package:controleRetirada/data/datasources/confirm/confirm_datasource.dart';
import 'package:controleRetirada/data/entities/confirm_request_entity.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';
import 'package:controleRetirada/commons/constants.dart';

class ConfirmRemoteDataSource implements ConfirmDataSource {
  final Dio _dio;
  ConfirmRemoteDataSource(this._dio);

  @override
  Future<ConfirmEntity> postInsertLaunchEvent(
    String tokenAPI,
    List<ConfirmRequestEntity> items,
  ) {
    return this
        ._dio
        .post(
          "$kUrlEvents/api/LaunchEvent/InsertLaunchEvent",
          queryParameters: {'tokenAPI': tokenAPI},
          data: confirmRequestEntityToJson(items),
        )
        .then((value) {
      ConfirmEntity response = ConfirmEntity();

      if (value.data != null) {
        response = ConfirmEntity.fromJson(value.data);
      }
      return response;
    });
  }
}
