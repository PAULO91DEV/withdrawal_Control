import 'package:controleRetirada/data/datasources/products/product_datasource.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';

class ProductMockDataSource implements ProductDataSource {
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
    return Future.delayed(Duration(seconds: 2)).then((_) {
      List<ProductEntity> products = <ProductEntity>[];
      ProductEntity product = ProductEntity(
          companyId: "101",
          siteId: "MATRIZ-VA",
          eventId: "1",
          productId: "1",
          productDescription: "copo",
          qtyMaximum: 30,
          qtyRemaining: 33,
          qtyPullout: 2,
          itemId: "1",
          partId: "-1",
          partDescription: "null",
          inventoryControl: 0,
          balance: 5,
          automaticDown: 1,
          booleanReturn: true,
          codeReturn: 0,
          descriptionReturn: "");
      products.add(product);
      return products;
    });
  }
}
