// To parse this JSON data, do
//
//     final modelPostQrCodeList = modelPostQrCodeListFromJson(jsonString);

import 'dart:convert';

ModelPostQrCodeList modelPostQrCodeListFromJson(String str) =>
    ModelPostQrCodeList.fromJson(json.decode(str));

String modelPostQrCodeListToJson(ModelPostQrCodeList data) =>
    json.encode(data.toJson());

class ModelPostQrCodeList {
  ModelPostQrCodeList({
    this.waters,
    this.electrics,
  });

  List<Electric> waters;
  List<Electric> electrics;

  factory ModelPostQrCodeList.fromJson(Map<String, dynamic> json) =>
      ModelPostQrCodeList(
        waters: json["waters"] == null
            ? null
            : List<Electric>.from(
                json["waters"].map((x) => Electric.fromJson(x))),
        electrics: json["electrics"] == null
            ? null
            : List<Electric>.from(
                json["electrics"].map((x) => Electric.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "waters": waters == null
            ? null
            : List<dynamic>.from(waters.map((x) => x.toJson())),
        "electrics": electrics == null
            ? null
            : List<dynamic>.from(electrics.map((x) => x.toJson())),
      };
}

class Electric {
  Electric({
    this.unitCode,
    this.type,
    this.bulan,
    this.tahun,
    this.nomorSeri,
    this.pemakaian,
    this.foto,
    this.insertBy,
    this.insertDate,
  });

  String unitCode;
  String type;
  String bulan;
  String tahun;
  String nomorSeri;
  String pemakaian;
  String foto;
  String insertBy;
  String insertDate;

  factory Electric.fromJson(Map<String, dynamic> json) => Electric(
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        type: json["type"] == null ? null : json["type"],
        bulan: json["bulan"] == null ? null : json["bulan"],
        tahun: json["tahun"] == null ? null : json["tahun"],
        nomorSeri: json["nomor_seri"] == null ? null : json["nomor_seri"],
        pemakaian: json["pemakaian"] == null ? null : json["pemakaian"],
        foto: json["foto"] == null ? null : json["foto"],
        insertBy: json["insert_by"] == null ? null : json["insert_by"],
      );

  Map<String, dynamic> toJson() => {
        "unit_code": unitCode == null ? null : unitCode,
        "type": type == null ? null : type,
        "bulan": bulan == null ? null : bulan,
        "tahun": tahun == null ? null : tahun,
        "nomor_seri": nomorSeri == null ? null : nomorSeri,
        "pemakaian": pemakaian == null ? null : pemakaian,
        "foto": foto == null ? null : foto,
        "insert_by": insertBy == null ? null : insertBy,
        "insert_date": insertDate == null ? null : insertDate,
      };
}
