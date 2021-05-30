// To parse this JSON data, do
//
//     final loginRequestEntity = loginRequestEntityFromJson(jsonString);

import 'dart:convert';

LoginRequestEntity loginRequestEntityFromJson(String str) =>
    LoginRequestEntity.fromJson(json.decode(str));

String loginRequestEntityToJson(LoginRequestEntity data) =>
    json.encode(data.toJson());

class LoginRequestEntity {
  LoginRequestEntity({
    this.login,
    this.senha,
  });

  String login;
  String senha;

  factory LoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      LoginRequestEntity(
        login: json["Login"] == null ? null : json["Login"],
        senha: json["Senha"] == null ? null : json["Senha"],
      );

  Map<String, dynamic> toJson() => {
        "Login": login == null ? null : login,
        "Senha": senha == null ? null : senha,
      };
}
