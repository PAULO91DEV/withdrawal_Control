// To parse this JSON data, do
//
//     final confirmRequestEntity = confirmRequestEntityFromJson(jsonString);

import 'dart:convert';

List<ConfirmRequestEntity> confirmRequestEntityFromJson(String str) =>
    List<ConfirmRequestEntity>.from(
        json.decode(str).map((x) => ConfirmRequestEntity.fromJson(x)));

String confirmRequestEntityToJson(List<ConfirmRequestEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConfirmRequestEntity {
  ConfirmRequestEntity({
    this.companyId,
    this.siteId,
    this.eventId,
    this.productId,
    this.itemId,
    this.partId,
    this.partUnit,
    this.personId,
    this.localId,
    this.userId,
    this.qtyPullout,
    this.inventoryControl,
    this.costPrice,
    this.costPriceHoliday,
  });

  String companyId;
  String siteId;
  String eventId;
  String productId;
  String itemId;
  String partId;
  String partUnit;
  String personId;
  String localId;
  String userId;
  String qtyPullout;
  String inventoryControl;
  double costPrice;
  double costPriceHoliday;

  factory ConfirmRequestEntity.fromJson(Map<String, dynamic> json) =>
      ConfirmRequestEntity(
        companyId: json["company_id"] == null ? null : json["company_id"],
        siteId: json["site_id"] == null ? null : json["site_id"],
        eventId: json["event_id"] == null ? null : json["event_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        itemId: json["item_id"] == null ? null : json["item_id"],
        partId: json["part_id"] == null ? null : json["part_id"],
        partUnit: json["part_unit"] == null ? null : json["part_unit"],
        personId: json["person_id"] == null ? null : json["person_id"],
        localId: json["local_id"] == null ? null : json["local_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        qtyPullout: json["qty_pullout"] == null ? null : json["qty_pullout"],
        inventoryControl: json["inventory_control"] == null
            ? null
            : json["inventory_control"],
        costPrice:
            json["cost_price"] == null ? null : json["cost_price"].toDouble(),
        costPriceHoliday: json["cost_price_holiday"] == null
            ? null
            : json["cost_price_holiday"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId == null ? null : companyId,
        "site_id": siteId == null ? null : siteId,
        "event_id": eventId == null ? null : eventId,
        "product_id": productId == null ? null : productId,
        "item_id": itemId == null ? null : itemId,
        "part_id": partId == null ? null : partId,
        "part_unit": partUnit == null ? null : partUnit,
        "person_id": personId == null ? null : personId,
        "local_id": localId == null ? null : localId,
        "user_id": userId == null ? null : userId,
        "qty_pullout": qtyPullout == null ? null : qtyPullout,
        "inventory_control": inventoryControl == null ? null : inventoryControl,
        "cost_price": costPrice == null ? null : costPrice,
        "cost_price_holiday":
            costPriceHoliday == null ? null : costPriceHoliday,
      };
}
