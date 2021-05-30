// To parse this JSON data, do
//
//     final itemsRequestEntity = itemsRequestEntityFromJson(jsonString);

import 'dart:convert';

ItemsRequestEntity itemsRequestEntityFromJson(String str) =>
    ItemsRequestEntity.fromJson(json.decode(str));

String itemsRequestEntityToJson(ItemsRequestEntity data) =>
    json.encode(data.toJson());

class ItemsRequestEntity {
  ItemsRequestEntity({
    this.companyId,
    this.siteId,
    this.eventId,
    this.accumulative,
    this.pulloutSingle,
  });

  String companyId;
  String siteId;
  String eventId;
  int accumulative;
  String pulloutSingle;

  factory ItemsRequestEntity.fromJson(Map<String, dynamic> json) =>
      ItemsRequestEntity(
        companyId: json["company_id"] == null ? null : json["company_id"],
        siteId: json["site_id"] == null ? null : json["site_id"],
        eventId: json["event_id"] == null ? null : json["event_id"],
        accumulative:
            json["accumulative"] == null ? null : json["accumulative"],
        pulloutSingle:
            json["pullout_single"] == null ? null : json["pullout_single"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId == null ? null : companyId,
        "site_id": siteId == null ? null : siteId,
        "event_id": eventId == null ? null : eventId,
        "accumulative": accumulative == null ? null : accumulative,
        "pullout_single": pulloutSingle == null ? null : pulloutSingle,
      };
}
