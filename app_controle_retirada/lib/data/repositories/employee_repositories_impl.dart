import 'package:controleRetirada/data/datasources/employee/employee_datasource.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';
import 'package:controleRetirada/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeDataSource _dataSource;

  EmployeeRepositoryImpl(this._dataSource);

  @override
  Future<EmployeeEntity> getEmployee(String getCode, String tokenAPI) {
    return this._dataSource.getEmployee(getCode, tokenAPI);
  }
}
