// To parse this JSON data, do
//
//     final modelResponLogin = modelResponLoginFromJson(jsonString);

import 'dart:convert';

ModelResponLogin modelResponLoginFromJson(String str) =>
    ModelResponLogin.fromJson(json.decode(str));

String modelResponLoginToJson(ModelResponLogin data) =>
    json.encode(data.toJson());

class ModelResponLogin {
  ModelResponLogin({
    this.status,
    this.remarks,
    this.dataUser,
  });

  bool status;
  String remarks;
  DataUser dataUser;

  factory ModelResponLogin.fromJson(Map<String, dynamic> json) =>
      ModelResponLogin(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        dataUser: json["data_user"] == null
            ? null
            : DataUser.fromJson(json["data_user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "data_user": dataUser == null ? null : dataUser.toJson(),
      };
}

class DataUser {
  DataUser({
    this.idUser,
    this.nik,
    this.fullName,
    this.nick,
    this.nickname,
    this.email,
    this.mobilePhone,
    this.businessUnit,
    this.location,
    this.floor,
    this.photo,
    this.password,
    this.pwdString,
    this.profileId,
    this.isMerchant,
    this.wallet,
    this.bankName,
    this.bankAccount,
    this.statusEmp,
    this.uploadKtp,
    this.uploadIdcard,
    this.isActive,
    this.insertDate,
    this.signPad,
    this.colorAgent,
  });

  String idUser;
  dynamic nik;
  String fullName;
  dynamic nick;
  String nickname;
  String email;
  String mobilePhone;
  String businessUnit;
  String location;
  String floor;
  dynamic photo;
  String password;
  String pwdString;
  String profileId;
  String isMerchant;
  dynamic wallet;
  dynamic bankName;
  dynamic bankAccount;
  String statusEmp;
  dynamic uploadKtp;
  dynamic uploadIdcard;
  String isActive;
  DateTime insertDate;
  dynamic signPad;
  dynamic colorAgent;

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        idUser: json["id_user"] == null ? null : json["id_user"],
        nik: json["nik"],
        fullName: json["full_name"] == null ? null : json["full_name"],
        nick: json["nick"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        email: json["email"] == null ? null : json["email"],
        mobilePhone: json["mobile_phone"] == null ? null : json["mobile_phone"],
        businessUnit:
            json["business_unit"] == null ? null : json["business_unit"],
        location: json["location"] == null ? null : json["location"],
        floor: json["floor"] == null ? null : json["floor"],
        photo: json["photo"],
        password: json["password"] == null ? null : json["password"],
        pwdString: json["pwd_string"] == null ? null : json["pwd_string"],
        profileId: json["profile_id"] == null ? null : json["profile_id"],
        isMerchant: json["is_merchant"] == null ? null : json["is_merchant"],
        wallet: json["wallet"],
        bankName: json["bank_name"],
        bankAccount: json["bank_account"],
        statusEmp: json["status_emp"] == null ? null : json["status_emp"],
        uploadKtp: json["upload_ktp"],
        uploadIdcard: json["upload_idcard"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        insertDate: json["insert_date"] == null
            ? null
            : DateTime.parse(json["insert_date"]),
        signPad: json["sign_pad"],
        colorAgent: json["color_agent"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser == null ? null : idUser,
        "nik": nik,
        "full_name": fullName == null ? null : fullName,
        "nick": nick,
        "nickname": nickname == null ? null : nickname,
        "email": email == null ? null : email,
        "mobile_phone": mobilePhone == null ? null : mobilePhone,
        "business_unit": businessUnit == null ? null : businessUnit,
        "location": location == null ? null : location,
        "floor": floor == null ? null : floor,
        "photo": photo,
        "password": password == null ? null : password,
        "pwd_string": pwdString == null ? null : pwdString,
        "profile_id": profileId == null ? null : profileId,
        "is_merchant": isMerchant == null ? null : isMerchant,
        "wallet": wallet,
        "bank_name": bankName,
        "bank_account": bankAccount,
        "status_emp": statusEmp == null ? null : statusEmp,
        "upload_ktp": uploadKtp,
        "upload_idcard": uploadIdcard,
        "is_active": isActive == null ? null : isActive,
        "insert_date": insertDate == null ? null : insertDate.toIso8601String(),
        "sign_pad": signPad,
        "color_agent": colorAgent,
      };
}
