import 'package:ai_barcode/ai_barcode.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:easymoveinapp/models/res_menus.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_progress.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/pages/menu/home.dart';
import 'package:easymoveinapp/sqlite/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QCCamera extends StatefulWidget {
  final Tbl_mkrt_unit mkrtUnit;
  final Menu menu;
  QCCamera({Key key, this.mkrtUnit, this.menu}) : super(key: key);
  @override
  _QCCameraState createState() => _QCCameraState();
}

class _QCCameraState extends State<QCCamera> {
  bool permissionCamera = false;
  ScannerController _scannerController;
  String type;
  String paramUnit = "";
  String paramUnitCode = "";
  String paramType = "";
  String table = "";
  String tableTemp = "";
  String textQR;
  String sesIduser;
  String sesName;
  String curMonth;
  String bulan;
  String tahun;

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Move In',
    );
    var result = await permissionValidator.camera();
    if (result) {
      permissionCamera = true;
    } else {
      permissionCamera = false;
    }
    if (mounted)
      setState(() {
        permissionCamera = permissionCamera;
      });
  }

  displayCamera() {
    print("=====================> Dispaly Camera");
    _scannerController = ScannerController(scannerResult: (result) {
      getData(context, result);
    }, scannerViewCreated: () {
      print("=====================> scannerViewCreated");
      TargetPlatform platform = Theme.of(context).platform;
      if (TargetPlatform.iOS == platform) {
        Future.delayed(Duration(seconds: 2), () {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
      } else {
        _scannerController.startCamera();
        _scannerController.startCameraPreview();
      }
    });
  }

  getData(BuildContext context, String unitCode) async {
    if (paramUnit + "-" + paramType != unitCode) {
      Navigator.pop(context);
      WidgetSnackbar(
          context: context,
          message: "Unit dan QR Code tidak sama",
          warna: "merah");
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => WidgetProgressSubmit(
                text: "Proses Get Data Detail Unit",
              ));
      Tbl_mkrt_unit dataQR;
      String last = unitCode.substring(unitCode.length - 1);

      if (last.toLowerCase() == 'a') {
        setState(() {
          type = "Water";
        });
      } else if (last.toLowerCase() == 'e') {
        setState(() {
          setState(() {
            type = "Electric";
          });
        });
      } else {
        WidgetSnackbar(
            context: context, message: "Invalid QR Code", warna: "merah");
      }
      if (type != null) {
        if (type.toLowerCase() == "water") {
          dataQR = await Tbl_mkrt_unit()
              .select()
              .water_id
              .equals(unitCode)
              .toSingle();
        } else {
          dataQR = await Tbl_mkrt_unit()
              .select()
              .electric_id
              .equals(unitCode)
              .toSingle();
        }
        Navigator.pop(context);
        if (dataQR == null) {
          WidgetSnackbar(
              context: context,
              message: "Unit not found, please synchronize before scan!",
              warna: "merah");
        } else {
          saveOK();
        }
      }
    }
  }

  back() {
    Navigator.pop(context);
  }

  saveOK() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());

    DateTime now = DateTime.now();
    if (now.day >= 19) {
      now = new DateTime(now.year, now.month + 1, now.day);
    }
    curMonth = DateFormat('MMM').format(now);
    tahun = DateFormat('y').format(now);
    bulan = DateFormat('MM').format(now);
    if (bulan == "12") {
      tahun = (int.parse(tahun) + 1).toString();
    }
    String insertDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    if (table == 'tbl_waters_qc') {
      var check = await Tbl_waters_temp_qc()
          .select()
          .unit_code
          .equals(paramUnitCode)
          .toSingle();
      if (check == null) {
        final dataSave = Tbl_waters_temp_qc();
        dataSave.type = "Water";
        dataSave.unit_code = paramUnitCode;
        dataSave.bulan = bulan;
        dataSave.tahun = tahun;
        dataSave.qc_check = '1';
        dataSave.qc_date = insertDate;
        dataSave.qc_id = sesIduser;
        final res = await dataSave.save();
        print("====================== INSERT WATER" + res.toString());
      } else {
        final res = await Tbl_waters_temp_qc()
            .select()
            .unit_code
            .equals(paramUnitCode)
            .update({
          "qc_check": '1',
          "qc_id": sesIduser,
          "qc_date": insertDate,
        });
        print("====================== UPDATE WATER" + res.toString());
      }
      final resDel = await Tbl_waters_temp_problem_qc()
          .select()
          .unit_code
          .equals(paramUnitCode)
          .delete();
      print(
          "====================== DELETE PROBLEM ELECTRIC" + resDel.toString());
    } else {
      var check = await Tbl_electrics_temp_qc()
          .select()
          .unit_code
          .equals(paramUnitCode)
          .toSingle();
      if (check == null) {
        final dataSave = Tbl_electrics_temp_qc();
        dataSave.type = "Electric";
        dataSave.unit_code = paramUnitCode;
        dataSave.bulan = bulan;
        dataSave.tahun = tahun;
        dataSave.qc_check = '1';
        dataSave.qc_date = insertDate;
        dataSave.qc_id = sesIduser;
        final res = await dataSave.save();
        print("====================== INSERT ELECTRIC" + res.toString());
      } else {
        final res = await Tbl_electrics_temp_qc()
            .select()
            .unit_code
            .equals(paramUnitCode)
            .update({
          "qc_check": '1',
          "qc_id": sesIduser,
          "qc_date": insertDate,
        });
        print("====================== UPDATE ELECTRIC" + res.toString());
      }
      final resDel = await Tbl_electrics_temp_problem_qc()
          .select()
          .unit_code
          .equals(paramUnitCode)
          .delete();
      print(
          "====================== DELETE PROBLEM ELECTRIC" + resDel.toString());
    }
    Navigator.pop(context);
    goToHome();
    WidgetSnackbar(
        context: context,
        message: "Successfuly saving to local",
        warna: "hijau");
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
    paramUnit = widget.mkrtUnit.blocks +
        "-" +
        widget.mkrtUnit.tower +
        "-" +
        widget.mkrtUnit.floor +
        "" +
        widget.mkrtUnit.tipe;
    paramUnitCode = widget.mkrtUnit.blocks +
        "-" +
        widget.mkrtUnit.tower +
        "-" +
        widget.mkrtUnit.floor +
        "-" +
        widget.mkrtUnit.floor +
        "" +
        widget.mkrtUnit.tipe;
    if (widget.menu.className == 'QCListrik') {
      paramType = "E";
      table = 'tbl_electrics_qc';
      tableTemp = 'tbl_electrics_temp_qc';
      textQR = "PELASE SCAN LISTRIK " + paramUnit;
    } else if (widget.menu.className == 'QCAir') {
      paramType = "A";
      table = 'tbl_waters_qc';
      tableTemp = 'tbl_waters_temp_qc';
      textQR = "PELASE SCAN AIR " + paramUnit;
    } else if (widget.menu.className == 'ReadingListrik') {
      paramType = "E";
      table = 'tbl_electrics';
      tableTemp = 'tbl_electrics_temp';
      textQR = "PELASE SCAN LISTRIK " + paramUnit;
    } else if (widget.menu.className == 'ReadingAir') {
      paramType = "A";
      table = 'tbl_waters';
      tableTemp = 'tbl_waters_temp';
      textQR = "PELASE SCAN AIR " + paramUnit;
    }
    _permissionRequest();
    displayCamera();
  }

  @override
  void dispose() {
    super.dispose();
    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return WillPopScope(
      onWillPop: () => back(),
      child: Scaffold(
        body: Stack(
          children: [
            PlatformAiBarcodeScannerWidget(
              platformScannerController: _scannerController,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(textQR + "-" + paramType),
                      )),
                )),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 8, top: 42),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                    )))
          ],
        ),
      ),
    );
  }
}
