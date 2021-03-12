// To parse this JSON data, do
//
//     final modelGeneralResponse = modelGeneralResponseFromJson(jsonString);

import 'dart:convert';

ModelGeneralResponse modelGeneralResponseFromJson(String str) =>
    ModelGeneralResponse.fromJson(json.decode(str));

String modelGeneralResponseToJson(ModelGeneralResponse data) =>
    json.encode(data.toJson());

class ModelGeneralResponse {
  ModelGeneralResponse({
    this.status,
    this.remarks,
    this.dateFrom,
    this.dateTo,
  });

  bool status;
  String remarks;
  String dateFrom;
  String dateTo;

  factory ModelGeneralResponse.fromJson(Map<String, dynamic> json) =>
      ModelGeneralResponse(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        dateFrom: json["date_from"] == null ? null : json["date_from"],
        dateTo: json["date_to"] == null ? null : json["date_to"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
      };
}
