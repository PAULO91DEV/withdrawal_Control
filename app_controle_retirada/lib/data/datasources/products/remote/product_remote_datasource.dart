import 'package:dio/dio.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/products/product_datasource.dart';
import 'package:controleRetirada/data/entities/products_request_entity.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';

class ProductRemoteDataSource implements ProductDataSource {
  // ignore: unused_field
  final Dio _dio;
  ProductRemoteDataSource(this._dio);

  @override
  Future<List<ProductEntity>> getProducts(
    String tokenAPI, //sharedPrefer
    String personId,
    String companyId, //EventEntity
    String siteId, //EventEntity
    String eventId, //EventEntity
    int accumulative,
    String pulloutSingle,
  ) {
    return this
        ._dio
        .post(
          "$kUrlProducts/api/eventProduct",
          queryParameters: {
            'tokenAPI': tokenAPI,
            'personId': personId,
          },
          data: ProductRequestEntity(
            companyId: companyId,
            siteId: siteId,
            eventId: eventId,
            accumulative: accumulative,
            pulloutSingle: pulloutSingle,
          ).toJson(),
        )
        .then((result) {
      List<ProductEntity> entities = <ProductEntity>[];

      /* if (result.data != null) {
        entities = (result.data as List)
            .map((x) => ProductEntity.fromJson(x))
            .toList();*/ //o codigo comentado valida se  os dados do resultado do product Entity não for Null, então ira percorrer a o map tranformando em Json

      result.data.forEach((e) {
        entities.add(ProductEntity.fromJson(e));
      });

      return entities;
    });
  }
}
