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
  });

  bool status;
  String remarks;
  List<Tbl_water> listWater;

  factory ModelSyncWaters.fromJson(Map<String, dynamic> json) =>
      ModelSyncWaters(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        listWater: json["list_water"] == null
            ? null
            : List<Tbl_water>.from(
                json["list_water"].map((x) => Tbl_water.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "list_water": listWater == null
            ? null
            : List<dynamic>.from(listWater.map((x) => x.toMap())),
      };
}
