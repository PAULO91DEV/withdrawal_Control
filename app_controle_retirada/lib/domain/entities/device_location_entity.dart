// To parse this JSON data, do
//
//     final deviceLocationEntity = deviceLocationEntityFromJson(jsonString);

import 'dart:convert';

DeviceLocationEntity deviceLocationEntityFromJson(String str) =>
    DeviceLocationEntity.fromJson(json.decode(str));

String deviceLocationEntityToJson(DeviceLocationEntity data) =>
    json.encode(data.toJson());

class DeviceLocationEntity {
  DeviceLocationEntity({
    this.macAddress,
    this.activateCode,
  });

  String macAddress;
  String activateCode;

  factory DeviceLocationEntity.fromJson(Map<String, dynamic> json) =>
      DeviceLocationEntity(
        macAddress: json["macAddress"] == null ? null : json["macAddress"],
        activateCode:
            json["activateCode"] == null ? null : json["activateCode"],
      );

  Map<String, dynamic> toJson() => {
        "macAddress": macAddress == null ? null : macAddress,
        "activateCode": activateCode == null ? null : activateCode,
      };
}
