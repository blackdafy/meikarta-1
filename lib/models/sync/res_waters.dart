// To parse this JSON data, do
//
//     final modelSyncWaters = modelSyncWatersFromJson(jsonString);

import 'dart:convert';

import 'package:easymoveinapp/sqlite/db.dart';

ModelSyncWaters modelSyncWatersFromJson(String str) =>
    ModelSyncWaters.fromJson(json.decode(str));

String modelSyncWatersToJson(ModelSyncWaters data) => json.encode(data.toMap());

class ModelSyncWaters {
  ModelSyncWaters({
    this.status,
    this.remarks,
    this.listWater,
    this.listWaterPR,
  });

  bool status;
  String remarks;
  List<Tbl_water> listWater;
  List<Tbl_waters_problem> listWaterPR;

  factory ModelSyncWaters.fromJson(Map<String, dynamic> json) =>
      ModelSyncWaters(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        listWater: json["list_water"] == null
            ? null
            : List<Tbl_water>.from(
                json["list_water"].map((x) => Tbl_water.fromMap(x))),
        listWaterPR: json["list_water_problem"] == null
            ? null
            : List<Tbl_waters_problem>.from(json["list_water_problem"]
                .map((x) => Tbl_waters_problem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "list_water": listWater == null
            ? null
            : List<dynamic>.from(listWater.map((x) => x.toMap())),
        "list_water_problem": listWaterPR == null
            ? null
            : List<dynamic>.from(listWaterPR.map((x) => x.toMap())),
      };
}
