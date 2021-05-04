// To parse this JSON data, do
//
//     final modelResponMasterProblem = modelResponMasterProblemFromJson(jsonString);

import 'dart:convert';

import 'package:easymoveinapp/sqlite/db.dart';

ModelResponMasterProblem modelResponMasterProblemFromJson(String str) =>
    ModelResponMasterProblem.fromJson(json.decode(str));

String modelResponMasterProblemToJson(ModelResponMasterProblem data) =>
    json.encode(data.toMap());

class ModelResponMasterProblem {
  ModelResponMasterProblem({
    this.status,
    this.remarks,
    this.dataProblem,
  });

  bool status;
  String remarks;
  List<Tbl_master_problem> dataProblem;

  factory ModelResponMasterProblem.fromJson(Map<String, dynamic> json) =>
      ModelResponMasterProblem(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        dataProblem: json["data_problem"] == null
            ? null
            : List<Tbl_master_problem>.from(
                json["data_problem"].map((x) => Tbl_master_problem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "data_problem": dataProblem == null
            ? null
            : List<dynamic>.from(dataProblem.map((x) => x.toMap())),
      };
}
