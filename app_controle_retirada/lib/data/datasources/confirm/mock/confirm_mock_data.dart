import 'package:controleRetirada/data/datasources/confirm/confirm_datasource.dart';
import 'package:controleRetirada/data/entities/confirm_request_entity.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';

class ConfirmMockData implements ConfirmDataSource {
  @override

  // ignore: override_on_non_overriding_member
  Future<List<ConfirmEntity>> getConfirm(
    String tokenAPI,
    String companyId,
    String siteId,
    String eventId,
    String productId,
    String itemId,
    String partId,
    String partUnit,
    String personId,
    String localId,
    String userId,
    String qtyPullout,
    int inventoryControl,
    double costPrice,
    double costPriceHoliday,
  ) {
    return Future.delayed(Duration(seconds: 2)).then((_) {
      List<ConfirmEntity> confirms = <ConfirmEntity>[];
      ConfirmEntity confirm = ConfirmEntity(
          codeReturn: 1,
          descriptionReturn: "Cannot deserialize the current JSON array ");
      confirms.add(confirm);
      return confirms;
    });
  }

  @override
  Future<ConfirmEntity> postInsertLaunchEvent(
      String tokenAPI, List<ConfirmRequestEntity> items) {
    return Future.delayed(Duration(seconds: 2)).then((_) {
      return ConfirmEntity(
          codeReturn: 1,
          descriptionReturn: "Cannot deserialize the current JSON array ");
    });
  }
}
