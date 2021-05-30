// To parse this JSON data, do
//
//     final activationEntity = activationEntityFromJson(jsonString);

import 'dart:convert';

ActivationEntity activationEntityFromJson(String str) =>
    ActivationEntity.fromJson(json.decode(str));

String activationEntityToJson(ActivationEntity data) =>
    json.encode(data.toJson());

class ActivationEntity {
  ActivationEntity({
    this.company,
    this.site,
    this.locationId,
    this.description,
    this.parameters,
  });

  String company;
  String site;
  String locationId;
  String description;
  List<Parameter> parameters;

  factory ActivationEntity.fromJson(Map<String, dynamic> json) =>
      ActivationEntity(
        company: json["company"] == null ? null : json["company"],
        site: json["site"] == null ? null : json["site"],
        locationId: json["locationId"] == null ? null : json["locationId"],
        description: json["description"] == null ? null : json["description"],
        parameters: json["parameters"] == null
            ? null
            : List<Parameter>.from(
                json["parameters"].map((x) => Parameter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "company": company == null ? null : company,
        "site": site == null ? null : site,
        "locationId": locationId == null ? null : locationId,
        "description": description == null ? null : description,
        "parameters": parameters == null
            ? null
            : List<dynamic>.from(parameters.map((x) => x.toJson())),
      };
}

class Parameter {
  Parameter({
    this.key,
    this.value,
  });

  String key;
  String value;

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        key: json["key"] == null ? null : json["key"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "value": value == null ? null : value,
      };
}
