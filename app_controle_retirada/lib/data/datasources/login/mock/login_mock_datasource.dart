import 'package:controleRetirada/data/datasources/login/login_datasource.dart';
import 'package:controleRetirada/domain/entities/login_entity.dart';

class LoginMockDataSource implements LoginDataSource {
  @override
  Future<LoginResponseEntity> signin(String login, String password) {
    return Future.delayed(Duration(seconds: 5)).then((_) {
      return LoginResponseEntity(
        token: "501bd954-dff3-42e4-ab1f-476676b88a2c",
      );
    });
  }
}
