// To parse this JSON data, do
//
//     final modelTempProblem = modelTempProblemFromJson(jsonString);

import 'dart:convert';

ModelTempProblem modelTempProblemFromJson(String str) =>
    ModelTempProblem.fromJson(json.decode(str));

String modelTempProblemToJson(ModelTempProblem data) =>
    json.encode(data.toJson());

class ModelTempProblem {
  ModelTempProblem({
    this.unitCode,
    this.tahun,
    this.bulan,
    this.problem,
  });

  String unitCode;
  String tahun;
  String bulan;
  String problem;

  factory ModelTempProblem.fromJson(Map<String, dynamic> json) =>
      ModelTempProblem(
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        tahun: json["tahun"] == null ? null : json["tahun"],
        bulan: json["bulan"] == null ? null : json["bulan"],
        problem: json["problem"] == null ? null : json["problem"],
      );

  Map<String, dynamic> toJson() => {
        "unit_code": unitCode == null ? null : unitCode,
        "tahun": tahun == null ? null : tahun,
        "bulan": bulan == null ? null : bulan,
        "problem": problem == null ? null : problem,
      };
}
