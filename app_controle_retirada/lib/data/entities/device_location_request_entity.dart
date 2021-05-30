// To parse this JSON data, do
//
//     final deviceLocationRequestEntity = deviceLocationRequestEntityFromJson(jsonString);

import 'dart:convert';

DeviceLocationRequestEntity deviceLocationRequestEntityFromJson(String str) =>
    DeviceLocationRequestEntity.fromJson(json.decode(str));

String deviceLocationRequestEntityToJson(DeviceLocationRequestEntity data) =>
    json.encode(data.toJson());

class DeviceLocationRequestEntity {
  DeviceLocationRequestEntity({
    this.macAddress,
    this.activateCode,
  });

  String macAddress;
  String activateCode;

  factory DeviceLocationRequestEntity.fromJson(Map<String, dynamic> json) =>
      DeviceLocationRequestEntity(
        macAddress: json["macAddress"] == null ? null : json["macAddress"],
        activateCode:
            json["activateCode"] == null ? null : json["activateCode"],
      );

  Map<String, dynamic> toJson() => {
        "macAddress": macAddress == null ? null : macAddress,
        "activateCode": activateCode == null ? null : activateCode,
      };
}
