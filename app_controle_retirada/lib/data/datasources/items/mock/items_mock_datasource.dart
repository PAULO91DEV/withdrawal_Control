import 'package:controleRetirada/data/datasources/items/items_datasource.dart';
import 'package:controleRetirada/domain/entities/items_entity.dart';

class ItemsMockDataSource implements ItemsDataSource {
  @override
  // ignore: missing_return
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
    return Future.delayed(Duration(seconds: 2)).then((_) {
      List<ItemEntity> items =
          <ItemEntity>[]; //items objeto da classe ItemsEntity
      ItemEntity item = ItemEntity(
          companyId: "101",
          siteId: "MATRIZ-VA",
          eventId: "2",
          productId: "1",
          productDescription: "Copo",
          qtyMaximum: 1,
          qtyRemaining: -3,
          qtyPullout: 4,
          itemId: "1",
          partId: "PO082-1",
          partDescription: "CX.1 C/56 POTE 230ML",
          inventoryControl: 1,
          balance: 0,
          automaticDown: 0,
          booleanReturn: true,
          codeReturn: 0,
          descriptionReturn: "");
      items.add(item);
      return items;
    });
  }
}
