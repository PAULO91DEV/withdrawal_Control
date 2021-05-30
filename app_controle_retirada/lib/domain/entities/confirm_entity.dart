// To parse this JSON data, do
//
//     final confirmEntity = confirmEntityFromJson(jsonString);

import 'dart:convert';

ConfirmEntity confirmEntityFromJson(String str) =>
    ConfirmEntity.fromJson(json.decode(str));

String confirmEntityToJson(ConfirmEntity data) => json.encode(data.toJson());

class ConfirmEntity {
  ConfirmEntity({
    this.companyId,
    this.siteId,
    this.eventId,
    this.launchId,
    this.productId,
    this.itemId,
    this.partId,
    this.partUnit,
    this.personId,
    this.localId,
    this.departamentId,
    this.launchDate,
    this.userId,
    this.qtyPullout,
    this.inventoryControl,
    this.costPrice,
    this.booleanReturn,
    this.codeReturn,
    this.descriptionReturn,
  });

  dynamic companyId;
  dynamic siteId;
  dynamic eventId;
  dynamic launchId;
  dynamic productId;
  dynamic itemId;
  dynamic partId;
  dynamic partUnit;
  dynamic personId;
  dynamic localId;
  dynamic departamentId;
  dynamic launchDate;
  dynamic userId;
  int qtyPullout;
  int inventoryControl;
  double costPrice;
  bool booleanReturn;
  int codeReturn;
  String descriptionReturn;

  factory ConfirmEntity.fromJson(Map<String, dynamic> json) => ConfirmEntity(
        companyId: json["company_id"],
        siteId: json["site_id"],
        eventId: json["event_id"],
        launchId: json["launch_id"],
        productId: json["product_id"],
        itemId: json["item_id"],
        partId: json["part_id"],
        partUnit: json["part_unit"],
        personId: json["person_id"],
        localId: json["local_id"],
        departamentId: json["departament_id"],
        launchDate: json["launch_date"],
        userId: json["user_id"],
        qtyPullout: json["qty_pullout"] == null ? null : json["qty_pullout"],
        inventoryControl: json["inventory_control"] == null
            ? null
            : json["inventory_control"],
        costPrice: json["cost_price"] == null ? null : json["cost_price"],
        booleanReturn:
            json["boolean_return"] == null ? null : json["boolean_return"],
        codeReturn: json["code_return"] == null ? null : json["code_return"],
        descriptionReturn: json["description_return"] == null
            ? null
            : json["description_return"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "site_id": siteId,
        "event_id": eventId,
        "launch_id": launchId,
        "product_id": productId,
        "item_id": itemId,
        "part_id": partId,
        "part_unit": partUnit,
        "person_id": personId,
        "local_id": localId,
        "departament_id": departamentId,
        "launch_date": launchDate,
        "user_id": userId,
        "qty_pullout": qtyPullout == null ? null : qtyPullout,
        "inventory_control": inventoryControl == null ? null : inventoryControl,
        "cost_price": costPrice == null ? null : costPrice,
        "boolean_return": booleanReturn == null ? null : booleanReturn,
        "code_return": codeReturn == null ? null : codeReturn,
        "description_return":
            descriptionReturn == null ? null : descriptionReturn,
      };
}
