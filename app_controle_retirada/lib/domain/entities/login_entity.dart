// To parse this JSON data, do
//
//     final loginResponseEntity = loginResponseEntityFromJson(jsonString);

import 'dart:convert';

LoginResponseEntity loginResponseEntityFromJson(String str) => LoginResponseEntity.fromJson(json.decode(str));

String loginResponseEntityToJson(LoginResponseEntity data) => json.encode(data.toJson());

class LoginResponseEntity {
  LoginResponseEntity({
    this.token,
    this.id,
    this.login,
    this.email,
    this.password,
    this.name,
    this.company,
    this.entity,
    this.business,
    this.language,
    this.serverConnected,
    this.resources,
    this.codigo,
    this.descricao,
  });

  String token;
  int id;
  String login;
  String email;
  String password;
  String name;
  String company;
  String entity;
  String business;
  String language;
  dynamic serverConnected;
  Map<String, List<String>> resources;
  int codigo;
  String descricao;

  factory LoginResponseEntity.fromJson(Map<String, dynamic> json) => LoginResponseEntity(
    token: json["Token"] == null ? null : json["Token"],
    id: json["Id"] == null ? null : json["Id"],
    login: json["Login"] == null ? null : json["Login"],
    email: json["Email"] == null ? null : json["Email"],
    password: json["Password"] == null ? null : json["Password"],
    name: json["Name"] == null ? null : json["Name"],
    company: json["Company"] == null ? null : json["Company"],
    entity: json["Entity"] == null ? null : json["Entity"],
    business: json["Business"] == null ? null : json["Business"],
    language: json["Language"] == null ? null : json["Language"],
    serverConnected: json["ServerConnected"],
    resources: json["Resources"] == null ? null : Map.from(json["Resources"]).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    codigo: json["Codigo"] == null ? null : json["Codigo"],
    descricao: json["Descricao"] == null ? null : json["Descricao"],
  );

  Map<String, dynamic> toJson() => {
    "Token": token == null ? null : token,
    "Id": id == null ? null : id,
    "Login": login == null ? null : login,
    "Email": email == null ? null : email,
    "Password": password == null ? null : password,
    "Name": name == null ? null : name,
    "Company": company == null ? null : company,
    "Entity": entity == null ? null : entity,
    "Business": business == null ? null : business,
    "Language": language == null ? null : language,
    "ServerConnected": serverConnected,
    "Resources": resources == null ? null : Map.from(resources).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    "Codigo": codigo == null ? null : codigo,
    "Descricao": descricao == null ? null : descricao,
  };
}
