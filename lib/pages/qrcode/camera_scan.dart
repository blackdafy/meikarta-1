import 'package:ai_barcode/ai_barcode.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:easymoveinapp/main_nav.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_progress.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/pages/qrcode/show_data_qr.dart';
import 'package:easymoveinapp/sqlite/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetCameraScan extends StatefulWidget {
  WidgetCameraScan({Key key}) : super(key: key);
  @override
  _WidgetCameraScanState createState() => _WidgetCameraScanState();
}

class _WidgetCameraScanState extends State<WidgetCameraScan> {
  bool permissionCamera = false;
  ScannerController _scannerController;
  String type;

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
    print("-> Dispaly Camera");
    _scannerController = ScannerController(scannerResult: (result) {
      getData(context, result);
    }, scannerViewCreated: () {
      print("-> scannerViewCreated");
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

  Future getData(BuildContext context, String unitCode) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());
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
        dataQR =
            await Tbl_mkrt_unit().select().water_id.equals(unitCode).toSingle();
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
        navigateTo(dataQR, type);
      }
    }
  }

  navigateTo(Tbl_mkrt_unit res, String type) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => ShowDataQR(
                  res: res,
                  type: type,
                )),
        (Route<dynamic> route) => false);
  }

  back() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainNav()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
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
      // ignore: missing_return
      onWillPop: () {
        back();
      },
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
                        child: Text("PLEASE SCAN BARCODE"),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
