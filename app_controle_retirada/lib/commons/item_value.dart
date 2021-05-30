import 'dart:convert';

import 'package:flutter/material.dart';

// class ItemValue {
//   final String label;
//   final dynamic value;
//   final String detail;

//   ItemValue(this.label, this.value, this.detail);
// }

// To parse this JSON data, do
//
//     final itemValue = itemValueFromJson(jsonString);

List<ItemValue> itemValueFromJson(String str) =>
    List<ItemValue>.from(json.decode(str).map((x) => ItemValue.fromJson(x)));

String itemValueToJson(List<ItemValue> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemValue {
  ItemValue({
    @required this.label,
    @required this.value,
    @required this.detail,
  });

  String label;
  dynamic value;
  String detail;

  factory ItemValue.fromJson(Map<String, dynamic> json) => ItemValue(
        label: json["label"] == null ? null : json["label"],
        value: json["value"] == null ? null : json["value"],
        detail: json["detail"] == null ? null : json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "label": label == null ? null : label,
        "value": value == null ? null : value,
        "detail": detail == null ? null : detail,
      };
}
