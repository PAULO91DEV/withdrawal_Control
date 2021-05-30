// To parse this JSON data, do
//
//     final productEntity = productEntityFromJson(jsonString);

import 'dart:convert';

List<ProductEntity> productEntityFromJson(String str) =>
    List<ProductEntity>.from(
        json.decode(str).map((x) => ProductEntity.fromJson(x)));

String productEntityToJson(List<ProductEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntity {
  ProductEntity({
    this.companyId,
    this.siteId,
    this.eventId,
    this.departamentId,
    this.productId,
    this.productDescription,
    this.qtyMaximum,
    this.qtyRemaining,
    this.qtyPullout,
    this.itemId,
    this.partId,
    this.partUnit,
    this.partDescription,
    this.inventoryControl,
    this.balance,
    this.automaticDown,
    this.existsItem,
    this.active,
    this.costPrice,
    this.costPriceHoliday,
    this.booleanReturn,
    this.codeReturn,
    this.descriptionReturn,
  });

  String companyId;
  String siteId;
  String eventId;
  dynamic departamentId;
  String productId;
  String productDescription;
  int qtyMaximum;
  int qtyRemaining;
  int qtyPullout;
  String itemId;
  String partId;
  String partUnit;
  String partDescription;
  int inventoryControl;
  int balance;
  int automaticDown;
  int existsItem;
  int active;
  double costPrice;
  double costPriceHoliday;
  bool booleanReturn;
  int codeReturn;
  String descriptionReturn;

  factory ProductEntity.fromJson(Map<String, dynamic> json) => ProductEntity(
        companyId: json["company_id"] == null ? null : json["company_id"],
        siteId: json["site_id"] == null ? null : json["site_id"],
        eventId: json["event_id"] == null ? null : json["event_id"],
        departamentId: json["departament_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        productDescription: json["product_description"] == null
            ? null
            : json["product_description"],
        qtyMaximum: json["qty_maximum"] == null ? null : json["qty_maximum"],
        qtyRemaining:
            json["qty_remaining"] == null ? null : json["qty_remaining"],
        qtyPullout: json["qty_pullout"] == null ? null : json["qty_pullout"],
        itemId: json["item_id"] == null ? null : json["item_id"],
        partId: json["part_id"] == null ? null : json["part_id"],
        partUnit: json["part_unit"] == null ? null : json["part_unit"],
        partDescription:
            json["part_description"] == null ? null : json["part_description"],
        inventoryControl: json["inventory_control"] == null
            ? null
            : json["inventory_control"],
        balance: json["balance"] == null ? null : json["balance"],
        automaticDown:
            json["automatic_down"] == null ? null : json["automatic_down"],
        existsItem: json["exists_item"] == null ? null : json["exists_item"],
        active: json["active"] == null ? null : json["active"],
        costPrice: json["cost_price"] == null ? null : json["cost_price"],
        costPriceHoliday: json["cost_price_holiday"] == null
            ? null
            : json["cost_price_holiday"],
        booleanReturn:
            json["boolean_return"] == null ? null : json["boolean_return"],
        codeReturn: json["code_return"] == null ? null : json["code_return"],
        descriptionReturn: json["description_return"] == null
            ? null
            : json["description_return"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId == null ? null : companyId,
        "site_id": siteId == null ? null : siteId,
        "event_id": eventId == null ? null : eventId,
        "departament_id": departamentId,
        "product_id": productId == null ? null : productId,
        "product_description":
            productDescription == null ? null : productDescription,
        "qty_maximum": qtyMaximum == null ? null : qtyMaximum,
        "qty_remaining": qtyRemaining == null ? null : qtyRemaining,
        "qty_pullout": qtyPullout == null ? null : qtyPullout,
        "item_id": itemId == null ? null : itemId,
        "part_id": partId == null ? null : partId,
        "part_unit": partUnit == null ? null : partUnit,
        "part_description": partDescription == null ? null : partDescription,
        "inventory_control": inventoryControl == null ? null : inventoryControl,
        "balance": balance == null ? null : balance,
        "automatic_down": automaticDown == null ? null : automaticDown,
        "exists_item": existsItem == null ? null : existsItem,
        "active": active == null ? null : active,
        "cost_price": costPrice == null ? null : costPrice,
        "cost_price_holiday":
            costPriceHoliday == null ? null : costPriceHoliday,
        "boolean_return": booleanReturn == null ? null : booleanReturn,
        "code_return": codeReturn == null ? null : codeReturn,
        "description_return":
            descriptionReturn == null ? null : descriptionReturn,
      };
}
