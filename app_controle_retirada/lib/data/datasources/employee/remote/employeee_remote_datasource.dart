import 'package:dio/dio.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/employee/employee_datasource.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';

class EmployeeRemoteDataSource implements EmployeeDataSource {
  final Dio _dio;
  EmployeeRemoteDataSource(this._dio);

  @override
  Future<EmployeeEntity> getEmployee(String getCode, String tokenAPI) {
    return this._dio.get(
      "$kUrlEmployee/api/entitycode",
      queryParameters: {
        "get_code": getCode,
        "tokenAPI": tokenAPI,
      },
    ).then((result) {
      if (result.data == null) {
        throw kEmployeeErrorText;
      }
      EmployeeEntity response = EmployeeEntity.fromJson(result.data);
      return response;
    });
  }
}
