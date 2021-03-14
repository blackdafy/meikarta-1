// To parse this JSON data, do
//
//     final modelSyncUnits = modelSyncUnitsFromJson(jsonString);

import 'dart:convert';

import 'package:easymoveinapp/sqlite/db.dart';

ModelSyncUnits modelSyncUnitsFromJson(String str) =>
    ModelSyncUnits.fromJson(json.decode(str));

String modelSyncUnitsToJson(ModelSyncUnits data) => json.encode(data.toMap());

class ModelSyncUnits {
  ModelSyncUnits({
    this.status,
    this.remarks,
    this.mkrtUnit,
  });

  bool status;
  String remarks;
  List<Tbl_mkrt_unit> mkrtUnit;

  factory ModelSyncUnits.fromJson(Map<String, dynamic> json) => ModelSyncUnits(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        mkrtUnit: json["list_mkrt_unit"] == null
            ? null
            : List<Tbl_mkrt_unit>.from(
                json["list_mkrt_unit"].map((x) => Tbl_mkrt_unit.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "list_mkrt_unit": mkrtUnit == null
            ? null
            : List<dynamic>.from(mkrtUnit.map((x) => x.toMap())),
      };
}
