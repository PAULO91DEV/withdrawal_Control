import 'package:controleRetirada/data/datasources/login/login_datasource.dart';
import 'package:controleRetirada/domain/entities/login_entity.dart';
import 'package:controleRetirada/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource _dataSource;
  LoginRepositoryImpl(this._dataSource);

  @override
  Future<LoginResponseEntity> signin(
    String login,
    String password,
  ) {
    return this._dataSource.signin(
          login,
          password,
        );
  }
}
//implementation.
