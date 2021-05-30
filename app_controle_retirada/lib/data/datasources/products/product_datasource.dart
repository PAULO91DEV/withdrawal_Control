import 'package:controleRetirada/domain/entities/products_entity.dart';

class ProductDataSource {
  // ignore: missing_return
  Future<List<ProductEntity>> getProducts(
    String tokenAPI, //sharedPrefer
    String personId,
    String companyId, //EventEntity
    String siteId, //EventEntity
    String eventId, //EventEntity
    int accumulative,
    String pulloutSingle,
  ) {}
}
