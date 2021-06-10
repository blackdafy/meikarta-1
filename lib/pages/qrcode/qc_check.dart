import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easymoveinapp/models/res_menus.dart';
import 'package:easymoveinapp/models/res_mkrt_unit.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_loading_page.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_progress.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_view_image.dart';
import 'package:easymoveinapp/pages/menu/home.dart';
import 'package:easymoveinapp/pages/qrcode/qc_camera.dart';
import 'package:easymoveinapp/sqlite/db.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QCCheck extends StatefulWidget {
  final Tbl_mkrt_unit mkrtUnit;
  final Menu menu;
  QCCheck({Key key, this.mkrtUnit, this.menu}) : super(key: key);
  @override
  _QCCheckState createState() => _QCCheckState();
}

class _QCCheckState extends State<QCCheck> {
  bool loading = true;
  String table = '';
  String tableTemp = '';
  String title = "";
  String blocks = "";
  String floor = "";
  String tower = "";
  String tipe = "";
  String unit = "";
  bool showPR = false;
  bool showPROther = false;
  Tbl_mkrt_unit dataUnit;
  List<Tbl_master_problem> listMasterProblem = [];
  List<Tbl_master_problem> listMasterProblemTemp = [];
  List<Tbl_master_problem> listMasterProblemTrue = [];

  List<Tbl_electrics_problem> listPRElectric = [];
  List<Tbl_waters_problem> listPRWater = [];
  List<Tbl_electrics_temp_problem_qc> listPRElectricTemp = [];
  List<Tbl_waters_temp_problem_qc> listPRWaterTemp = [];

  List<Electric> dataList = [];
  String lastMeteran = "0";
  String lastMonth = "0";
  String lastYear = "0";
  String curMonth = "";
  String bulan;
  String tahun;
  final ScrollController _scrollController = ScrollController();
  String sesIduser;
  String sesName;

  getData(String unit) async {
    listMasterProblem =
        await Tbl_master_problem().select().type.equals("QC").toList();
    dataUnit = await Tbl_mkrt_unit().select().unit_code.equals(unit).toSingle();
    setState(() {
      loading = true;
      dataUnit = dataUnit;
      listMasterProblem = listMasterProblem;
      listMasterProblemTemp = listMasterProblem;
    });
    getDataList();
    setProblem(unit);
  }

  setProblem(unit) async {
    if (table == 'tbl_electrics_qc') {
      listPRElectricTemp = await Tbl_electrics_temp_problem_qc()
          .select()
          .unit_code
          .equals(unit)
          .and
          .tahun
          .equals(tahun)
          .and
          .bulan
          .equals(bulan)
          .toList();

      if (listPRElectricTemp.length > 0) {
        setState(() {
          listPRElectricTemp = listPRElectricTemp;
        });
        setProblemTemp(unit);
      } else {
        listPRElectric = await Tbl_electrics_problem()
            .select()
            .unit_code
            .equals(unit)
            .and
            .tahun
            .equals(tahun)
            .and
            .bulan
            .equals(bulan)
            .and
            .type
            .equals("QC")
            .toList();
        for (var i in listPRElectric) {
          final changeTo = listMasterProblemTemp
              .firstWhere((item) => item.idx == i.idx_problem);
          changeTo.is_checked = true;
        }
      }
    } else {
      listPRWaterTemp = await Tbl_waters_temp_problem_qc()
          .select()
          .unit_code
          .equals(unit)
          .and
          .tahun
          .equals(tahun)
          .and
          .bulan
          .equals(bulan)
          .toList();
      if (listPRWaterTemp.length > 0) {
        setState(() {
          listPRWaterTemp = listPRWaterTemp;
        });
        setProblemTemp(unit);
      } else {
        listPRWater = await Tbl_waters_problem()
            .select()
            .unit_code
            .equals(unit)
            .and
            .tahun
            .equals(tahun)
            .and
            .bulan
            .equals(bulan)
            .and
            .type
            .equals("QC")
            .toList();
        for (var i in listPRWater) {
          final changeTo = listMasterProblemTemp
              .firstWhere((item) => item.idx == i.idx_problem);
          changeTo.is_checked = true;
        }
      }
    }
    setState(() {
      listMasterProblemTrue =
          listMasterProblemTemp.where((i) => i.is_checked).toList();
      showPR = listMasterProblemTrue.length > 0 ? true : false;
    });
    showOther();
  }

  setProblemTemp(unit) async {
    if (table == 'tbl_electrics_qc') {
      for (var i in listPRElectricTemp) {
        final changeTo = listMasterProblemTemp
            .firstWhere((item) => item.idx == i.idx_problem);
        changeTo.is_checked = true;
      }
    } else {
      for (var i in listPRWaterTemp) {
        final changeTo = listMasterProblemTemp
            .firstWhere((item) => item.idx == i.idx_problem);
        changeTo.is_checked = true;
      }
    }
    setState(() {
      listMasterProblemTrue =
          listMasterProblemTemp.where((i) => i.is_checked).toList();
      showPR = listMasterProblemTrue.length > 0 ? true : false;
      for (var i in listMasterProblemTemp) {
        print(i.idx + " " + i.is_checked.toString());
      }
    });
    showOther();
  }

  showOther() {
    setState(() {
      showPROther =
          listMasterProblemTemp.firstWhere((i) => i.idx == '98').is_checked;
    });
  }

  textBulan(bulan) {
    switch (bulan) {
      case "01":
        return "Jan";
        break;
      case "02":
        return "Feb";
        break;
      case "03":
        return "Mar";
        break;
      case "04":
        return "Apr";
        break;
      case "05":
        return "May";
        break;
      case "06":
        return "Jun";
        break;
      case "07":
        return "Jul";
        break;
      case "08":
        return "Aug";
        break;
      case "09":
        return "Aug";
        break;
      case "10":
        return "Sep";
        break;
      case "11":
        return "Nov";
        break;
      case "12":
        return "Dec";
        break;
    }
  }

  minBulan(bulan) {
    switch (bulan) {
      case "01":
        return "12";
        break;
      case "02":
        return "01";
        break;
      case "03":
        return "02";
        break;
      case "04":
        return "03";
        break;
      case "05":
        return "04";
        break;
      case "06":
        return "05";
        break;
      case "07":
        return "06";
        break;
      case "08":
        return "07";
        break;
      case "09":
        return "08";
        break;
      case "10":
        return "09";
        break;
      case "11":
        return "10";
        break;
      case "12":
        return "11";
        break;
    }
  }

  gotoEnd() {
    if (_scrollController.hasClients)
      Timer(Duration(seconds: 1), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
  }

  getDataList() async {
    DateTime now = DateTime.now();
    if (now.day >= 19) {
      now = new DateTime(now.year, now.month + 1, now.day);
    }
    setState(() {
      curMonth = DateFormat('MMM').format(now);
      tahun = DateFormat('y').format(now);
      bulan = DateFormat('MM').format(now);
      if (bulan == "12") {
        tahun = (int.parse(tahun) + 1).toString();
      }
    });

    if (table == 'tbl_waters_qc') {
      var dataWater = await Tbl_water()
          .select()
          .unit_code
          .equals(unit)
          .orderBy("bulan")
          .toList();

      for (var item in dataWater) {
        dataList.add(new Electric(
          idx: item.idx,
          unitCode: item.unit_code,
          bulanText: textBulan(item.bulan),
          bulan: item.bulan,
          tahun: item.tahun,
          meteran: item.meteran,
          foto: item.foto,
          tanggalinput: item.tanggalinput,
          petugas: item.petugas,
          pemakaian: item.pemakaian,
        ));
        lastMeteran = item.meteran;
        lastMonth = item.bulan;
        lastYear = item.tahun;
      }
      Tbl_water data =
          await Tbl_water().select().unit_code.equals(unit).toSingle();
      if (data == null) {
        lastMeteran = "0";
      } else {
        Tbl_water data = await Tbl_water()
            .select()
            .unit_code
            .equals(unit)
            .and
            .bulan
            .equals(bulan)
            .and
            .tahun
            .equals(tahun)
            .toSingle();
        if (data != null) {
          String minusBulan = minBulan(data.bulan);
          String minusTahun = tahun;
          if (minusBulan == "01") {
            minusTahun = (int.parse(tahun) - 1).toString();
          }
          Tbl_water dataMin = await Tbl_water()
              .select()
              .unit_code
              .equals(unit)
              .and
              .bulan
              .equals(minBulan(data.bulan))
              .and
              .tahun
              .equals(minusTahun)
              .toSingle();
          if (dataMin != null) {
            lastMeteran = dataMin.bulan;
          }
        }
      }
    } else {
      var dataElectric = await Tbl_electric()
          .select()
          .unit_code
          .equals(unit)
          .orderBy("bulan")
          .toList();

      for (var item in dataElectric) {
        dataList.add(new Electric(
          idx: item.idx,
          unitCode: item.unit_code,
          bulanText: textBulan(item.bulan),
          bulan: item.bulan,
          tahun: item.tahun,
          meteran: item.meteran,
          foto: item.foto,
          tanggalinput: item.tanggalinput,
          petugas: item.petugas,
          pemakaian: item.pemakaian,
        ));
        lastMeteran = item.meteran;
        lastMonth = item.bulan;
        lastYear = item.tahun;
      }
      Tbl_electric data =
          await Tbl_electric().select().unit_code.equals(unit).toSingle();
      if (data == null) {
        lastMeteran = "0";
      } else {
        Tbl_electric data = await Tbl_electric()
            .select()
            .unit_code
            .equals(unit)
            .and
            .bulan
            .equals(bulan)
            .and
            .tahun
            .equals(tahun)
            .toSingle();
        if (data != null) {
          String minusBulan = minBulan(data.bulan);
          String minusTahun = tahun;
          if (minusBulan == "01") {
            minusTahun = (int.parse(tahun) - 1).toString();
          }
          Tbl_electric dataMin = await Tbl_electric()
              .select()
              .unit_code
              .equals(unit)
              .and
              .bulan
              .equals(minBulan(data.bulan))
              .and
              .tahun
              .equals(minusTahun)
              .toSingle();
          if (dataMin != null) {
            lastMeteran = dataMin.bulan;
          }
        }
      }
    }

    setState(() {
      curMonth = curMonth + " " + tahun;
      dataList = dataList.where((e) => e.meteran != null).toList();
      lastMeteran = lastMeteran;
      loading = false;
    });
  }

  checkUnCheckProblem(String id, bool statusParam) {
    setState(() {
      final changeTo =
          listMasterProblemTemp.firstWhere((item) => item.idx == id);
      changeTo.is_checked = statusParam;
      listMasterProblemTrue =
          listMasterProblemTemp.where((i) => i.is_checked).toList();
    });
  }

  confirmProblem(String type) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Konfirmasi",
      desc: "Apakah anda yakin akan submit " + type + " ?",
      buttons: [
        DialogButton(
            child: Text(
              "BATAL",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.red),
        DialogButton(
          child: Text(
            "SUBMIT",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            if (type == "OK") {
              saveOK();
            } else {
              savePR();
            }
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        )
      ],
    ).show();
  }

  saveOK() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                QCCamera(menu: widget.menu, mkrtUnit: widget.mkrtUnit)));
  }

  savePR() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());

    DateTime now = DateTime.now();
    String insertDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    if (table == 'tbl_waters_qc') {
      var check = await Tbl_waters_temp_qc()
          .select()
          .unit_code
          .equals(unit)
          .and
          .bulan
          .equals(bulan)
          .toSingle();
      if (check == null) {
        final dataSave = Tbl_waters_temp_qc();
        dataSave.type = "Water";
        dataSave.unit_code = unit;
        dataSave.bulan = bulan;
        dataSave.tahun = tahun;
        dataSave.qc_check = '2';
        dataSave.qc_date = insertDate;
        dataSave.qc_id = sesIduser;
        final res = await dataSave.save();
      } else {
        final res = await Tbl_waters_temp_qc()
            .select()
            .unit_code
            .equals(unit)
            .and
            .bulan
            .equals(bulan)
            .update({
          "qc_check": '2',
          "qc_id": sesIduser,
          "qc_date": insertDate,
        });
      }
    } else {
      var check = await Tbl_electrics_temp_qc()
          .select()
          .unit_code
          .equals(unit)
          .and
          .bulan
          .equals(bulan)
          .toSingle();
      if (check == null) {
        final dataSave = Tbl_electrics_temp_qc();
        dataSave.type = "Electric";
        dataSave.unit_code = unit;
        dataSave.bulan = bulan;
        dataSave.tahun = tahun;
        dataSave.qc_check = '2';
        dataSave.qc_date = insertDate;
        dataSave.qc_id = sesIduser;
        final res = await dataSave.save();
      } else {
        final res = await Tbl_electrics_temp_qc()
            .select()
            .unit_code
            .equals(unit)
            .and
            .bulan
            .equals(bulan)
            .update({
          "qc_check": '2',
          "qc_id": sesIduser,
          "qc_date": insertDate,
        });
      }
    }
    saveListProblem();
    Navigator.pop(context);
    goToHome();
    WidgetSnackbar(
        context: context,
        message: "Successfuly saving to local",
        warna: "hijau");
  }

  saveListProblem() async {
    if (table == 'tbl_electrics_qc') {
      await Tbl_electrics_temp_problem_qc()
          .select()
          .unit_code
          .equals(unit)
          .and
          .tahun
          .equals(bulan)
          .and
          .bulan
          .equals(bulan)
          .delete();
      for (var item in listMasterProblemTrue) {
        final dataSave = Tbl_electrics_temp_problem_qc();
        dataSave.unit_code = unit;
        dataSave.bulan = bulan;
        dataSave.tahun = tahun;
        dataSave.idx_problem = item.idx;
        final res = await dataSave.save();
      }
    } else {
      await Tbl_waters_temp_problem_qc()
          .select()
          .unit_code
          .equals(unit)
          .and
          .tahun
          .equals(bulan)
          .and
          .bulan
          .equals(bulan)
          .delete();
      for (var item in listMasterProblemTrue) {
        final dataSave = Tbl_waters_temp_problem_qc();
        dataSave.unit_code = unit;
        dataSave.bulan = bulan;
        dataSave.tahun = tahun;
        dataSave.idx_problem = item.idx;
        final res = await dataSave.save();
      }
    }
  }

  getSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      sesIduser = preferences.getString("PREF_IDUSER");
      sesName = preferences.getString("PREF_FULLNAME");
    });
  }

  goToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    getSession();
    title = widget.menu.titleName;
    blocks = widget.mkrtUnit.blocks;
    tower = widget.mkrtUnit.tower;
    floor = widget.mkrtUnit.floor;
    tipe = widget.mkrtUnit.tipe;
    unit = blocks + "-" + tower + "-" + floor + "-" + floor + "" + tipe;
    getData(unit);
    if (widget.menu.className == 'QCListrik') {
      table = 'tbl_electrics_qc';
      tableTemp = 'tbl_electrics_temp_qc';
    } else if (widget.menu.className == 'QCAir') {
      table = 'tbl_waters_qc';
      tableTemp = 'tbl_waters_temp_qc';
    } else if (widget.menu.className == 'ReadingListrik') {
      table = 'tbl_electrics';
      tableTemp = 'tbl_electrics_temp';
    } else if (widget.menu.className == 'ReadingAir') {
      table = 'tbl_waters';
      tableTemp = 'tbl_waters_temp';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorsTheme.primary1),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            title,
            style: TextStyle(color: ColorsTheme.primary1),
          ),
          elevation: 0,
        ),
        body: loading
            ? WidgetLoadingPage()
            : SingleChildScrollView(
                controller: _scrollController,
                reverse: true,
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    blocks,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: ColorsTheme.primary1,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: ColorsTheme.primary1,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8)),
                                    width: SizeConfig.screenWidth * 0.175,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          tower,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.screenWidth * 0.02),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  color: Colors.white,
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: ColorsTheme.primary1)),
                                    width: SizeConfig.screenWidth * 0.175,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          floor + "" + tipe,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: ColorsTheme.primary1,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                width: SizeConfig.screenWidth,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 12, right: 12, top: 8, bottom: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Detail Customer",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: ColorsTheme.text1,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        informasiPribadiRow(
                                            "Nama",
                                            dataUnit.customer_name
                                                .toUpperCase()),
                                        SizedBox(height: 4),
                                        informasiPribadiRow(
                                            "Tanggal HO",
                                            dataUnit.date_ho == null
                                                ? ""
                                                : dataUnit.date_ho),
                                        SizedBox(height: 4),
                                        informasiPribadiRow(
                                            "Tanggal MI",
                                            dataUnit.tanggal_dari == null
                                                ? ""
                                                : dataUnit.tanggal_dari),
                                        SizedBox(height: 4),
                                        informasiPribadiRow(
                                            "AVG 2 Bulan",
                                            table == 'tbl_waters_qc'
                                                ? dataUnit.avg_water
                                                : dataUnit.avg_electric == null
                                                    ? ""
                                                    : table == 'tbl_waters_qc'
                                                        ? dataUnit.avg_water
                                                        : dataUnit.avg_electric)
                                      ],
                                    )),
                              ),
                            ),
                          ),
                          ExpandableNotifier(
                            child: Column(
                              children: [
                                Expandable(
                                  collapsed: ExpandableButton(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Container(
                                        width: SizeConfig.screenWidth,
                                        color: ColorsTheme.background1,
                                        child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        "History Meteran")),
                                                Icon(Icons.arrow_circle_down)
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  expanded: Column(children: [
                                    ExpandableButton(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Container(
                                          width: SizeConfig.screenWidth,
                                          color: ColorsTheme.background1,
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          "History Meteran")),
                                                  Icon(Icons.arrow_circle_up)
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: dataList.length,
                                        itemBuilder:
                                            (BuildContext content, int index) {
                                          Electric item = dataList[index];
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              detailRow(
                                                  context,
                                                  item.bulanText,
                                                  item.tanggalinput,
                                                  item.petugas,
                                                  item.foto,
                                                  item.meteran,
                                                  item.pemakaian),
                                            ],
                                          );
                                        }),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 12, right: 12, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: MaterialButton(
                                        onPressed: () {
                                          if (listMasterProblemTrue.length ==
                                              0) {
                                            confirmProblem("OK");
                                          } else {
                                            WidgetSnackbar(
                                                context: context,
                                                message:
                                                    "Ada problem yang di checklist",
                                                warna: "merah");
                                          }
                                        },
                                        color: ColorsTheme.hijau,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.045,
                                        elevation: 0,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.screenWidth * 0.05),
                                Expanded(
                                  child: Container(
                                    child: MaterialButton(
                                        onPressed: () {
                                          gotoEnd();
                                          setState(() {
                                            showPR = showPR ? false : true;
                                          });
                                        },
                                        color: ColorsTheme.merah,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.045,
                                        elevation: 0,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          "PROBLEM",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          showPR
                              ? Column(children: [
                                  ListView.builder(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: listMasterProblemTemp.length,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        title: Text(listMasterProblemTemp[index]
                                            .problem),
                                        value: listMasterProblemTemp[index]
                                            .is_checked,
                                        contentPadding: EdgeInsets.all(0),
                                        activeColor: ColorsTheme.primary1,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        onChanged: (val) {
                                          checkUnCheckProblem(
                                              listMasterProblemTemp[index].idx,
                                              val);
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    width: SizeConfig.screenWidth,
                                    child: MaterialButton(
                                        onPressed: () {
                                          if (listMasterProblemTrue.length >
                                              0) {
                                            confirmProblem("Problem");
                                          } else {
                                            WidgetSnackbar(
                                                context: context,
                                                message:
                                                    "Tidak ada problem yang di checklist",
                                                warna: "merah");
                                          }
                                        },
                                        color: ColorsTheme.merah,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.045,
                                        elevation: 0,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          "SUBMIT PROBLEM",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )),
                                  ),
                                ])
                              : Container()
                        ]))));
  }

  Widget informasiPribadiRow(String key, String value) {
    return Row(
      children: [
        Container(
          width: SizeConfig.screenWidth * 0.3,
          child: Text(key),
          padding: EdgeInsets.only(bottom: 4),
        ),
        Text(": "),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget detailRow(
    BuildContext context,
    String bulan,
    String tanggalinput,
    String petugas,
    String foto,
    String meteran,
    String pemakaian,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          width: SizeConfig.screenWidth,
          child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bulan,
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorsTheme.text1,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            informasiPribadiRow("Tanggal Input", tanggalinput),
                            informasiPribadiRow("Petugas", petugas),
                            informasiPribadiRow("Angka Meteran", meteran),
                            informasiPribadiRow("Pemakaian", pemakaian)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewImage(
                                              header: "Preview",
                                              urlImage: foto,
                                            )));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: CachedNetworkImage(
                                    imageUrl: foto,
                                    fit: BoxFit.fill,
                                    placeholder:
                                        (BuildContext context, String url) {
                                      return Container(
                                        height: 40,
                                        color: ColorsTheme.background1,
                                      );
                                    },
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
