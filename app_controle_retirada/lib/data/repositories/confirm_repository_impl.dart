import 'package:controleRetirada/data/datasources/confirm/confirm_datasource.dart';
import 'package:controleRetirada/data/entities/confirm_request_entity.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';

import 'package:controleRetirada/domain/repositories/confirm_repository.dart';

class ConfirmRepositoryImpl implements ConfirmRepository {
  final ConfirmDataSource _dataSource;
  ConfirmRepositoryImpl(this._dataSource);

  @override
  Future<ConfirmEntity> postInsertLaunchEvent(
      String tokenAPI, List<ConfirmRequestEntity> items) {
    return this._dataSource.postInsertLaunchEvent(tokenAPI, items);
  }
}
