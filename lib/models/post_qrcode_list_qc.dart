// To parse this JSON data, do
//
//     final modelPostQrCodeListQc = modelPostQrCodeListQcFromJson(jsonString);

import 'dart:convert';

import 'package:easymoveinapp/models/post_qrcode_list.dart';

String modelPostQrCodeListQcToJson(ModelPostQrCodeListQc data) =>
    json.encode(data.toJson());

class ModelPostQrCodeListQc {
  ModelPostQrCodeListQc({
    this.electricQc,
    this.waterQc,
    this.electricsProblemQc,
    this.watersProblemQc,
  });

  List<WaterElectricQc> electricQc;
  List<WaterElectricQc> waterQc;
  List<WaterElectricProblem> electricsProblemQc;
  List<WaterElectricProblem> watersProblemQc;

  Map<String, dynamic> toJson() => {
        "waters": waterQc == null
            ? null
            : List<dynamic>.from(waterQc.map((x) => x.toJson())),
        "electrics": electricQc == null
            ? null
            : List<dynamic>.from(electricQc.map((x) => x.toJson())),
        "electrics_problem": electricsProblemQc == null
            ? null
            : List<dynamic>.from(electricsProblemQc.map((x) => x.toJson())),
        "waters_problem": watersProblemQc == null
            ? null
            : List<dynamic>.from(watersProblemQc.map((x) => x.toJson())),
      };
}

class WaterElectricQc {
  WaterElectricQc({
    this.unitCode,
    this.type,
    this.bulan,
    this.tahun,
    this.qcCheck,
    this.qcDate,
    this.qcId,
  });

  String unitCode;
  String type;
  String bulan;
  String tahun;
  String qcCheck;
  String qcDate;
  String qcId;

  factory WaterElectricQc.fromJson(Map<String, dynamic> json) =>
      WaterElectricQc(
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        type: json["type"] == null ? null : json["type"],
        bulan: json["bulan"] == null ? null : json["bulan"],
        tahun: json["tahun"] == null ? null : json["tahun"],
        qcCheck: json["qc_check"] == null ? null : json["qc_check"],
        qcDate: json["qc_date"] == null ? null : json["qc_date"],
        qcId: json["qc_id"] == null ? null : json["qc_id"],
      );

  Map<String, dynamic> toJson() => {
        "unit_code": unitCode == null ? null : unitCode,
        "type": type == null ? null : type,
        "bulan": bulan == null ? null : bulan,
        "tahun": tahun == null ? null : tahun,
        "qc_check": qcCheck == null ? null : qcCheck,
        "qc_date": qcDate == null ? null : qcDate,
        "qc_id": qcId == null ? null : qcId,
      };
}
