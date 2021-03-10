// To parse this JSON data, do
//
//     final modelPostQr = modelPostQrFromJson(jsonString);

import 'dart:convert';

ModelPostQr modelPostQrFromJson(String str) =>
    ModelPostQr.fromJson(json.decode(str));

String modelPostQrToJson(ModelPostQr data) => json.encode(data.toJson());

class ModelPostQr {
  ModelPostQr({
    this.unitCode,
    this.type,
  });

  String unitCode;
  String type;

  factory ModelPostQr.fromJson(Map<String, dynamic> json) => ModelPostQr(
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "unit_code": unitCode == null ? null : unitCode,
        "type": type == null ? null : type,
      };
}
