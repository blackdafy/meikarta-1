// To parse this JSON data, do
//
//     final modelSyncElectrics = modelSyncElectricsFromJson(jsonString);

import 'dart:convert';

import 'package:easymoveinapp/sqlite/db.dart';

ModelSyncElectrics modelSyncElectricsFromJson(String str) =>
    ModelSyncElectrics.fromJson(json.decode(str));

String modelSyncElectricsToJson(ModelSyncElectrics data) =>
    json.encode(data.toMap());

class ModelSyncElectrics {
  bool status;
  String remarks;
  List<Tbl_electric> listElectric;
  List<Tbl_electrics_problem> listElectricProblem;

  ModelSyncElectrics({
    this.status,
    this.remarks,
    this.listElectric,
    this.listElectricProblem,
  });

  factory ModelSyncElectrics.fromJson(Map<String, dynamic> json) =>
      ModelSyncElectrics(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        listElectric: json["list_electric"] == null
            ? null
            : List<Tbl_electric>.from(
                json["list_electric"].map((x) => Tbl_electric.fromMap(x))),
        listElectricProblem: json["list_electric_problem"] == null
            ? null
            : List<Tbl_electrics_problem>.from(json["list_electric_problem"]
                .map((x) => Tbl_electrics_problem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "list_electric": listElectric == null
            ? null
            : List<dynamic>.from(listElectric.map((x) => x.toMap())),
        "list_electric_problem": listElectric == null
            ? null
            : List<dynamic>.from(listElectricProblem.map((x) => x.toMap())),
      };
}
