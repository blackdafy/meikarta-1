// To parse this JSON data, do
//
//     final modelPostQrCodeList = modelPostQrCodeListFromJson(jsonString);

import 'dart:convert';

String modelPostQrCodeListToJson(ModelPostQrCodeList data) =>
    json.encode(data.toJson());

class ModelPostQrCodeList {
  ModelPostQrCodeList({
    this.electrics,
    this.waters,
    this.electricsProblem,
    this.watersProblem,
  });

  List<WaterElectric> electrics;
  List<WaterElectric> waters;
  List<WaterElectricProblem> electricsProblem;
  List<WaterElectricProblem> watersProblem;

  Map<String, dynamic> toJson() => {
        "waters": waters == null
            ? null
            : List<dynamic>.from(waters.map((x) => x.toJson())),
        "electrics": electrics == null
            ? null
            : List<dynamic>.from(electrics.map((x) => x.toJson())),
        "electrics_problem": electricsProblem == null
            ? null
            : List<dynamic>.from(electricsProblem.map((x) => x.toJson())),
        "waters_problem": watersProblem == null
            ? null
            : List<dynamic>.from(watersProblem.map((x) => x.toJson())),
      };
}

class WaterElectric {
  WaterElectric({
    this.unitCode,
    this.type,
    this.bulan,
    this.tahun,
    this.nomorSeri,
    this.pemakaian,
    this.foto,
    this.insertDate,
    this.insertBy,
    this.problem,
  });

  String unitCode;
  String type;
  String bulan;
  String tahun;
  String nomorSeri;
  String pemakaian;
  String foto;
  String insertDate;
  String insertBy;
  String problem;

  factory WaterElectric.fromJson(Map<String, dynamic> json) => WaterElectric(
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        type: json["type"] == null ? null : json["type"],
        bulan: json["bulan"] == null ? null : json["bulan"],
        tahun: json["tahun"] == null ? null : json["tahun"],
        nomorSeri: json["nomor_seri"] == null ? null : json["nomor_seri"],
        pemakaian: json["pemakaian"] == null ? null : json["pemakaian"],
        foto: json["foto"] == null ? null : json["foto"],
        insertDate: json["insert_date"] == null ? null : json["insert_date"],
        insertBy: json["insert_by"] == null ? null : json["insert_by"],
        problem: json["problem"] == null ? null : json["problem"],
      );

  Map<String, dynamic> toJson() => {
        "unit_code": unitCode == null ? null : unitCode,
        "type": type == null ? null : type,
        "bulan": bulan == null ? null : bulan,
        "tahun": tahun == null ? null : tahun,
        "nomor_seri": nomorSeri == null ? null : nomorSeri,
        "pemakaian": pemakaian == null ? null : pemakaian,
        "foto": foto == null ? null : foto,
        "insert_date": insertDate == null ? null : insertDate,
        "insert_by": insertBy == null ? null : insertBy,
        "problem": problem == null ? null : problem,
      };
}

class WaterElectricProblem {
  WaterElectricProblem({
    this.unitCode,
    this.bulan,
    this.tahun,
    this.idxProblem,
    this.type,
  });

  String unitCode;
  String bulan;
  String tahun;
  String idxProblem;
  String type;

  factory WaterElectricProblem.fromJson(Map<String, dynamic> json) =>
      WaterElectricProblem(
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        bulan: json["bulan"] == null ? null : json["bulan"],
        tahun: json["tahun"] == null ? null : json["tahun"],
        idxProblem: json["idx_problem"] == null ? null : json["idx_problem"],
      );

  Map<String, dynamic> toJson() => {
        "unit_code": unitCode == null ? null : unitCode,
        "bulan": bulan == null ? null : bulan,
        "tahun": tahun == null ? null : tahun,
        "idx_problem": idxProblem == null ? null : idxProblem,
        "type": type == null ? null : type,
      };
}
