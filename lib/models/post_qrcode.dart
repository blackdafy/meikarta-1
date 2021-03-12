// To parse this JSON data, do
//
//     final modelPostQrCode = modelPostQrCodeFromJson(jsonString);

import 'dart:convert';

ModelPostQrCode modelPostQrCodeFromJson(String str) =>
    ModelPostQrCode.fromJson(json.decode(str));

String modelPostQrCodeToJson(ModelPostQrCode data) =>
    json.encode(data.toJson());

class ModelPostQrCode {
  ModelPostQrCode({
    this.unitCode,
    this.type,
    this.bulan,
    this.tahun,
    this.nomorSeri,
    this.pemakaian,
    this.foto,
    this.insertBy,
  });

  String unitCode;
  String type;
  String bulan;
  String tahun;
  String nomorSeri;
  String pemakaian;
  String foto;
  String insertBy;

  factory ModelPostQrCode.fromJson(Map<String, dynamic> json) =>
      ModelPostQrCode(
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
      };
}
