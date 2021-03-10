// To parse this JSON data, do
//
//     final modelResponMkrtUnit = modelResponMkrtUnitFromJson(jsonString);

import 'dart:convert';

ModelResponMkrtUnit modelResponMkrtUnitFromJson(String str) =>
    ModelResponMkrtUnit.fromJson(json.decode(str));

String modelResponMkrtUnitToJson(ModelResponMkrtUnit data) =>
    json.encode(data.toJson());

class ModelResponMkrtUnit {
  ModelResponMkrtUnit({
    this.status,
    this.remarks,
    this.electric,
    this.water,
    this.mkrtUnit,
  });

  bool status;
  String remarks;
  List<Electric> electric;
  List<Electric> water;
  MkrtUnit mkrtUnit;

  factory ModelResponMkrtUnit.fromJson(Map<String, dynamic> json) =>
      ModelResponMkrtUnit(
        status: json["status"] == null ? "" : json["status"],
        remarks: json["remarks"] == null ? "" : json["remarks"],
        electric: json["electric"] == null
            ? null
            : List<Electric>.from(
                json["electric"].map((x) => Electric.fromJson(x))),
        water: json["water"] == null
            ? null
            : List<Electric>.from(
                json["water"].map((x) => Electric.fromJson(x))),
        mkrtUnit: json["mkrt_unit"] == null
            ? null
            : MkrtUnit.fromJson(json["mkrt_unit"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? "" : status,
        "remarks": remarks == null ? "" : remarks,
        "electric": electric == null
            ? null
            : List<dynamic>.from(electric.map((x) => x.toJson())),
        "water": water == null
            ? null
            : List<dynamic>.from(water.map((x) => x.toJson())),
        "mkrt_unit": mkrtUnit == null ? "" : mkrtUnit.toJson(),
      };
}

class Electric {
  Electric({
    this.idx,
    this.unitCode,
    this.bulan,
    this.nomorSeri,
    this.foto,
    this.insertDate,
    this.insertBy,
    this.updateBy,
    this.updateDate,
    this.petugas,
  });

  String idx;
  String unitCode;
  String bulan;
  String nomorSeri;
  String foto;
  String insertDate;
  String insertBy;
  String updateBy;
  String updateDate;
  String petugas;

  factory Electric.fromJson(Map<String, dynamic> json) => Electric(
        idx: json["idx"] == null ? "" : json["idx"],
        unitCode: json["unit_code"] == null ? "" : json["unit_code"],
        bulan: json["bulan"] == null ? "" : json["bulan"],
        nomorSeri: json["nomor_seri"] == null ? "" : json["nomor_seri"],
        foto: json["foto"] == null ? "" : json["foto"],
        insertDate: json["insert_date"] == null ? "" : json["insert_date"],
        insertBy: json["insert_by"] == null ? "" : json["insert_by"],
        updateBy: json["update_by"] == null ? "" : json["update_by"],
        updateDate: json["update_date"] == null ? "" : json["update_date"],
        petugas: json["petugas"] == null ? "" : json["petugas"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx == null ? "" : idx,
        "unit_code": unitCode == null ? "" : unitCode,
        "bulan": bulan == null ? "" : bulan,
        "nomor_seri": nomorSeri == null ? "" : nomorSeri,
        "foto": foto == null ? "" : foto,
        "insert_date": insertDate == null ? "" : insertDate,
        "insert_by": insertBy == null ? "" : insertBy,
        "update_by": updateBy == null ? "" : updateBy,
        "update_date": updateDate == null ? "" : updateDate,
        "petugas": petugas == null ? "" : petugas,
      };
}

class MkrtUnit {
  MkrtUnit({
    this.unitCode,
    this.customerName,
    this.customerAddress,
    this.email,
    this.electricId,
    this.waterId,
    this.phone,
    this.pppu,
    this.datePppu,
    this.dateHo,
    this.eligible,
    this.tanggalDari,
    this.tanggalSampai,
  });

  String unitCode;
  String customerName;
  String customerAddress;
  String email;
  String electricId;
  String waterId;
  String phone;
  String pppu;
  String datePppu;
  String dateHo;
  String eligible;
  String tanggalDari;
  String tanggalSampai;

  factory MkrtUnit.fromJson(Map<String, dynamic> json) => MkrtUnit(
        unitCode: json["unit_code"] == null ? "" : json["unit_code"],
        customerName:
            json["customer_name"] == null ? "" : json["customer_name"],
        customerAddress:
            json["customer_address"] == null ? "" : json["customer_address"],
        email: json["email"] == null ? "" : json["email"],
        electricId: json["electric_id"] == null ? "" : json["electric_id"],
        waterId: json["water_id"] == null ? "" : json["water_id"],
        phone: json["phone"] == null ? "" : json["phone"],
        pppu: json["pppu"] == null ? "" : json["pppu"],
        datePppu: json["date_pppu"] == null ? "" : json["date_pppu"],
        dateHo: json["date_ho"] == null ? "" : json["date_ho"],
        eligible: json["eligible"] == null ? "" : json["eligible"],
        tanggalDari: json["tanggal_dari"] == null ? "" : json["tanggal_dari"],
        tanggalSampai:
            json["tanggal_sampai"] == null ? "" : json["tanggal_sampai"],
      );

  Map<String, dynamic> toJson() => {
        "unit_code": unitCode == null ? "" : unitCode,
        "customer_name": customerName == null ? "" : customerName,
        "customer_address": customerAddress == null ? "" : customerAddress,
        "email": email == null ? "" : email,
        "electric_id": electricId == null ? "" : electricId,
        "water_id": waterId == null ? "" : waterId,
        "phone": phone == null ? "" : phone,
        "pppu": pppu == null ? "" : pppu,
        "date_pppu": datePppu == null ? "" : datePppu,
        "date_ho": dateHo == null ? "" : dateHo,
        "eligible": eligible == null ? "" : eligible,
        "tanggal_dari": tanggalDari == null ? "" : tanggalDari,
        "tanggal_sampai": tanggalSampai == null ? "" : tanggalSampai,
      };
}
