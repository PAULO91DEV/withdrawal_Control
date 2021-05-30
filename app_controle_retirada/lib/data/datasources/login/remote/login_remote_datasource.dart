import 'package:dio/dio.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/login/login_datasource.dart';
import 'package:controleRetirada/data/entities/login_request_entity.dart';
import 'package:controleRetirada/domain/entities/login_entity.dart';

class LoginRemoteDataSource implements LoginDataSource {
  final Dio _dio;
  LoginRemoteDataSource(this._dio);
  @override
  Future<LoginResponseEntity> signin(
    String login,
    String password,
  ) {
    return this
        ._dio
        .post(
          '$kUrlLogin/api/auth',
          queryParameters: {
            "gt_login": login,
          },
          data: LoginRequestEntity(
            login: login,
            senha: password,
          ).toJson(),
        )
        .then((value) {
      LoginResponseEntity response = LoginResponseEntity.fromJson(value.data);

      if (response.descricao == kLoginErrorText) {
        throw kLoginErrorText;
      }
      return response;
    });
  }
}
