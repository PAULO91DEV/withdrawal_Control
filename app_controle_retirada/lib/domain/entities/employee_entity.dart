// To parse this JSON data, do
//
//     final employeeEntity = employeeEntityFromJson(jsonString);

import 'dart:convert';

EmployeeEntity employeeEntityFromJson(String str) =>
    EmployeeEntity.fromJson(json.decode(str));

String employeeEntityToJson(EmployeeEntity data) => json.encode(data.toJson());

class EmployeeEntity {
  EmployeeEntity({
    this.code,
    this.businessId,
    this.businessEntityId,
    this.businessEntityType,
    this.entityTypeLanguage,
    this.name,
    this.tradingName,
    this.departamentId,
    this.description,
    this.initials,
    this.booleanReturn,
    this.codeReturn,
    this.descriptionReturn,
  });

  String code;
  String businessId;
  String businessEntityId;
  String businessEntityType;
  String entityTypeLanguage;
  String name;
  String tradingName;
  dynamic departamentId;
  dynamic description;
  dynamic initials;
  bool booleanReturn;
  int codeReturn;
  String descriptionReturn;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) => EmployeeEntity(
        code: json["code"] == null ? null : json["code"],
        businessId: json["business_id"] == null ? null : json["business_id"],
        businessEntityId: json["business_entity_id"] == null
            ? null
            : json["business_entity_id"],
        businessEntityType: json["business_entity_type"] == null
            ? null
            : json["business_entity_type"],
        entityTypeLanguage: json["entity_type_language"] == null
            ? null
            : json["entity_type_language"],
        name: json["name"] == null ? null : json["name"],
        tradingName: json["trading_name"] == null ? null : json["trading_name"],
        departamentId: json["departament_id"],
        description: json["description"],
        initials: json["initials"],
        booleanReturn:
            json["boolean_return"] == null ? null : json["boolean_return"],
        codeReturn: json["code_return"] == null ? null : json["code_return"],
        descriptionReturn: json["description_return"] == null
            ? null
            : json["description_return"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "business_id": businessId == null ? null : businessId,
        "business_entity_id":
            businessEntityId == null ? null : businessEntityId,
        "business_entity_type":
            businessEntityType == null ? null : businessEntityType,
        "entity_type_language":
            entityTypeLanguage == null ? null : entityTypeLanguage,
        "name": name == null ? null : name,
        "trading_name": tradingName == null ? null : tradingName,
        "departament_id": departamentId,
        "description": description,
        "initials": initials,
        "boolean_return": booleanReturn == null ? null : booleanReturn,
        "code_return": codeReturn == null ? null : codeReturn,
        "description_return":
            descriptionReturn == null ? null : descriptionReturn,
      };
}
