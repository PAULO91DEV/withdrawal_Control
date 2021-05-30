import 'package:controleRetirada/data/datasources/items/items_datasource.dart';
import 'package:controleRetirada/domain/entities/items_entity.dart';
import 'package:controleRetirada/domain/repositories/items_repository.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsDataSource _dataSource;
  ItemsRepositoryImpl(this._dataSource);

  @override
  Future<List<ItemEntity>> getItems(
    String productId,
    String personId,
    String tokenAPI,
    String companyId,
    String siteId,
    String eventId,
    int accumulative,
    String pulloutSingle,
  ) {
    return this._dataSource.getItems(
          productId,
          personId,
          tokenAPI,
          companyId,
          siteId,
          eventId,
          accumulative,
          pulloutSingle,
        );
  }
}
