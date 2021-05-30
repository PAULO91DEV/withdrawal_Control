import 'package:controleRetirada/data/datasources/products/product_datasource.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';
import 'package:controleRetirada/domain/repositories/products_repository.dart';

class ProductsRepositorioImpl implements ProductRepository {
  final ProductDataSource _dataSource;
  ProductsRepositorioImpl(this._dataSource);

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
    return this._dataSource.getProducts(
          tokenAPI,
          personId,
          companyId,
          siteId,
          eventId,
          accumulative,
          pulloutSingle,
        );
  }
}
