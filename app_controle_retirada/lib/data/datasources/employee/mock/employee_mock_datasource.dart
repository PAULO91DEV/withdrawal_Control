import 'package:controleRetirada/data/datasources/employee/employee_datasource.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';

class EmployeeMockDataSource implements EmployeeDataSource {
  @override
  Future<EmployeeEntity> getEmployee(String code, String tokenAPI) {
    return Future.delayed(Duration(seconds: 5)).then((_) {
      EmployeeEntity employeeEntity;
      if (code == "13175301878") {
        employeeEntity = EmployeeEntity(
          code: "13175301878",
          businessId: "13175301878",
          businessEntityId: "13175301878",
          businessEntityType: "Employee",
          tradingName: "Milton Benedito dos Santos Junior",
          departamentId: "1",
          description: "Produção",
          initials: "PROD",
          booleanReturn: false,
          codeReturn: 0,
        );
      }
      return employeeEntity;
    });
  }
}
