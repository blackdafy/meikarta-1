import 'dart:convert';

ModelPostLogin modelPostLoginFromJson(String str) =>
    ModelPostLogin.fromJson(json.decode(str));

String modelPostLoginToJson(ModelPostLogin data) => json.encode(data.toJson());

class ModelPostLogin {
  ModelPostLogin({
    this.email,
    this.password,
  });

  String email;
  String password;

  factory ModelPostLogin.fromJson(Map<String, dynamic> json) => ModelPostLogin(
        email: json["email"] == null ? null : json["email"],
        password: json["password"] == null ? null : json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email == null ? null : email,
        "password": password == null ? null : password,
      };
}
