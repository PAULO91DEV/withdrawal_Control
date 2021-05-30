// To parse this JSON data, do
//
//     final eventEntity = eventEntityFromJson(jsonString);

import 'dart:convert';

List<EventEntity> eventEntityFromJson(String str) => List<EventEntity>.from(
    json.decode(str).map((x) => EventEntity.fromJson(x)));

String eventEntityToJson(List<EventEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventEntity {
  EventEntity({
    this.companyId,
    this.siteId,
    this.eventId,
    this.description,
    this.pulloutSingle,
    this.validFrom,
    this.validTo,
    this.active,
    this.accumulative,
    this.entityType,
    this.createdBy,
    this.departamentId,
    this.showEvent,
    this.booleanReturn,
    this.codeReturn,
    this.descriptionReturn,
  });

  String companyId;
  String siteId;
  String eventId;
  String description;
  int pulloutSingle;
  String validFrom;
  dynamic validTo;
  int active;
  int accumulative;
  String entityType;
  dynamic createdBy;
  String departamentId;
  int showEvent;
  bool booleanReturn;
  int codeReturn;
  String descriptionReturn;

  factory EventEntity.fromJson(Map<String, dynamic> json) => EventEntity(
        companyId: json["company_id"] == null ? null : json["company_id"],
        siteId: json["site_id"] == null ? null : json["site_id"],
        eventId: json["event_id"] == null ? null : json["event_id"],
        description: json["description"] == null ? null : json["description"],
        pulloutSingle:
            json["pullout_single"] == null ? null : json["pullout_single"],
        validFrom: json["valid_from"] == null ? null : json["valid_from"],
        validTo: json["valid_to"],
        active: json["active"] == null ? null : json["active"],
        accumulative:
            json["accumulative"] == null ? null : json["accumulative"],
        entityType: json["entity_type"] == null ? null : json["entity_type"],
        createdBy: json["created_by"],
        departamentId:
            json["departament_id"] == null ? null : json["departament_id"],
        showEvent: json["show_event"] == null ? null : json["show_event"],
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
        "description": description == null ? null : description,
        "pullout_single": pulloutSingle == null ? null : pulloutSingle,
        "valid_from": validFrom == null ? null : validFrom,
        "valid_to": validTo,
        "active": active == null ? null : active,
        "accumulative": accumulative == null ? null : accumulative,
        "entity_type": entityType == null ? null : entityType,
        "created_by": createdBy,
        "departament_id": departamentId == null ? null : departamentId,
        "show_event": showEvent == null ? null : showEvent,
        "boolean_return": booleanReturn == null ? null : booleanReturn,
        "code_return": codeReturn == null ? null : codeReturn,
        "description_return":
            descriptionReturn == null ? null : descriptionReturn,
      };
}
