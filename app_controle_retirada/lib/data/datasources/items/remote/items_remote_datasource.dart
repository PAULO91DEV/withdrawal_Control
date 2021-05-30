import 'package:controleRetirada/domain/entities/items_entity.dart';
import 'package:dio/dio.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/items/items_datasource.dart';
import 'package:controleRetirada/data/entities/items_request_entity.dart';

class ItemsRemoteDataSource implements ItemsDataSource {
  final Dio _dio;
  ItemsRemoteDataSource(this._dio);

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
    return this
        ._dio
        .post(
          "$kUrlEvents/api/eventProduct",
          queryParameters: {
            'productId': productId,
            'personId': personId,
            'tokenAPI': tokenAPI,
          },
          data: ItemsRequestEntity(
            companyId: companyId,
            siteId: siteId,
            eventId: eventId,
            accumulative: accumulative,
            pulloutSingle: pulloutSingle,
          ).toJson(),
        )
        .then((value) {
      List<ItemEntity> entitiesRequest = <ItemEntity>[];
      value.data.forEach((e) {
        entitiesRequest.add(ItemEntity.fromJson(e));
      });
      return entitiesRequest;
    });
  }
}
