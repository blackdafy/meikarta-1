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
    this.lastMeteranE,
    this.lastMeteranA,
    this.electric,
    this.water,
    this.curMonth,
    this.mkrtUnit,
  });

  bool status;
  String remarks;
  String lastMeteranE;
  String lastMeteranA;
  List<Electric> electric;
  List<Electric> water;
  String curMonth;
  MkrtUnit mkrtUnit;

  factory ModelResponMkrtUnit.fromJson(Map<String, dynamic> json) =>
      ModelResponMkrtUnit(
        status: json["status"] == null ? null : json["status"],
        remarks: json["remarks"] == null ? null : json["remarks"],
        lastMeteranE:
            json["last_meteran_e"] == null ? null : json["last_meteran_e"],
        lastMeteranA:
            json["last_meteran_a"] == null ? null : json["last_meteran_a"],
        electric: json["electric"] == null
            ? null
            : List<Electric>.from(
                json["electric"].map((x) => Electric.fromJson(x))),
        water: json["water"] == null
            ? null
            : List<Electric>.from(
                json["water"].map((x) => Electric.fromJson(x))),
        curMonth: json["cur_month"] == null ? null : json["cur_month"],
        mkrtUnit: json["mkrt_unit"] == null
            ? null
            : MkrtUnit.fromJson(json["mkrt_unit"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "remarks": remarks == null ? null : remarks,
        "last_meteran_e": lastMeteranE == null ? null : lastMeteranE,
        "last_meteran_a": lastMeteranA == null ? null : lastMeteranA,
        "electric": electric == null
            ? null
            : List<dynamic>.from(electric.map((x) => x.toJson())),
        "water": water == null
            ? null
            : List<dynamic>.from(water.map((x) => x.toJson())),
        "cur_month": curMonth == null ? null : curMonth,
        "mkrt_unit": mkrtUnit == null ? null : mkrtUnit.toJson(),
      };
}

class Electric {
  Electric({
    this.idx,
    this.unitCode,
    this.bulanText,
    this.bulan,
    this.tahun,
    this.meteran,
    this.foto,
    this.tanggalinput,
    this.petugas,
    this.pemakaian,
  });

  String idx;
  String unitCode;
  String bulanText;
  String bulan;
  String tahun;
  String meteran;
  String foto;
  String tanggalinput;
  String petugas;
  String pemakaian;

  factory Electric.fromJson(Map<String, dynamic> json) => Electric(
        idx: json["idx"] == null ? null : json["idx"],
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        bulanText: json["bulan_text"] == null ? null : json["bulan_text"],
        bulan: json["bulan"] == null ? null : json["bulan"],
        tahun: json["tahun"] == null ? null : json["tahun"],
        meteran: json["meteran"] == null ? null : json["meteran"],
        foto: json["foto"] == null ? null : json["foto"],
        tanggalinput:
            json["tanggalinput"] == null ? null : json["tanggalinput"],
        petugas: json["petugas"] == null ? null : json["petugas"],
        pemakaian: json["pemakaian"] == null ? null : json["pemakaian"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx == null ? null : idx,
        "unit_code": unitCode == null ? null : unitCode,
        "bulan_text": bulanText == null ? null : bulanText,
        "bulan": bulan == null ? null : bulan,
        "tahun": tahun == null ? null : tahun,
        "meteran": meteran == null ? null : meteran,
        "foto": foto == null ? null : foto,
        "tanggalinput": tanggalinput == null ? null : tanggalinput,
        "petugas": petugas == null ? null : petugas,
        "pemakaian": pemakaian == null ? null : pemakaian,
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
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        customerName:
            json["customer_name"] == null ? null : json["customer_name"],
        customerAddress:
            json["customer_address"] == null ? null : json["customer_address"],
        email: json["email"] == null ? null : json["email"],
        electricId: json["electric_id"] == null ? null : json["electric_id"],
        waterId: json["water_id"] == null ? null : json["water_id"],
        phone: json["phone"] == null ? null : json["phone"],
        pppu: json["pppu"] == null ? null : json["pppu"],
        datePppu: json["date_pppu"] == null ? null : json["date_pppu"],
        dateHo: json["date_ho"] == null ? null : json["date_ho"],
        eligible: json["eligible"] == null ? null : json["eligible"],
        tanggalDari: json["tanggal_dari"] == null ? null : json["tanggal_dari"],
        tanggalSampai:
            json["tanggal_sampai"] == null ? null : json["tanggal_sampai"],
      );

  Map<String, dynamic> toJson() => {
        "unit_code": unitCode == null ? null : unitCode,
        "customer_name": customerName == null ? null : customerName,
        "customer_address": customerAddress == null ? null : customerAddress,
        "email": email == null ? null : email,
        "electric_id": electricId == null ? null : electricId,
        "water_id": waterId == null ? null : waterId,
        "phone": phone == null ? null : phone,
        "pppu": pppu == null ? null : pppu,
        "date_pppu": datePppu == null ? null : datePppu,
        "date_ho": dateHo == null ? null : dateHo,
        "eligible": eligible == null ? null : eligible,
        "tanggal_dari": tanggalDari == null ? null : tanggalDari,
        "tanggal_sampai": tanggalSampai == null ? null : tanggalSampai,
      };
}
