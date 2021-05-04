import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:easymoveinapp/api/service.dart';
import 'package:easymoveinapp/models/post_qrcode_list.dart';
import 'package:easymoveinapp/pages/auth/login.dart';
import 'package:easymoveinapp/pages/bottom_nav/fab_bottom_app_bar.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/pages/qrcode/camera_scan.dart';
import 'package:easymoveinapp/sqlite/db.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:easymoveinapp/pages/menu/data_electric.dart';
import 'package:easymoveinapp/pages/menu/data_water.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/general_widgets/widget_progress.dart';

class MainNav extends StatefulWidget {
  final String title;
  MainNav({Key key, this.title}) : super(key: key);
  @override
  _MainNavState createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> with TickerProviderStateMixin {
  int index = 0;
  String title = "Data Electric";
  bool permissionCamera = false;
  bool isConnect = true;
  List<Tbl_electric> listElectric = [];
  List<Tbl_water> listWater = [];
  List<Tbl_mkrt_unit> listMkrtUnit = [];
  int countTempWater = 0;
  int countTempElectric = 0;
  int totalTemp = 0;

  void _selectedTab(int ind) {
    setState(() {
      if (ind == 0) {
        title = "Data Electric";
      } else if (ind == 1) {
        title = "Data Water";
      }
      index = ind;
    });
  }

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

  void _selectedFab() {
    if (permissionCamera) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WidgetCameraScan()),
          (Route<dynamic> route) => false);
    } else {
      _permissionRequest();
    }
  }

  // ignore: missing_return
  Widget currentPage(int index) {
    if (index == 0) {
      setState(() {
        title = "Data Electric";
      });
      return DataEletric();
    } else if (index == 1) {
      setState(() {
        title = "Data Water";
      });
      return DataWater();
    }
  }

  Timer timer;
  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('easymovein.id');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (mounted)
          setState(() {
            isConnect = true;
          });
      }
    } on SocketException catch (_) {
      setState(() {
        isConnect = false;
      });
    }
  }

  displayDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Confirmation')),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  //USERNAME FIELD
                  Text("Are you sure exit this app ?")
                ]),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight1, bottom: 8),
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      child: SizedBox(
                        height: SizeConfig.screenHeight * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: Colors.white,
                          child: Text(
                            "NO",
                            style: TextStyle(
                                color: ColorsTheme.text1,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.screenLeftRight1, bottom: 8),
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      child: SizedBox(
                        height: SizeConfig.screenHeight * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            goToLogin();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: ColorsTheme.primary1,
                          child: Text(
                            "YES",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  getRange() {
    getClient().getRangeInput().then((res) async {
      // Navigator.pop(context);
      if (res.status) {
      } else {
        WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
      }
    }).catchError((Object obj) {
      WidgetSnackbar(
          context: context,
          message: "Failed connect to server!",
          warna: "merah");
    });
  }

  syncUpload() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());

    ModelPostQrCodeList dataPost = new ModelPostQrCodeList();
    List<Electric> electrics = [];
    List<Electric> waters = [];
    var dataElectric = await Tbl_electrics_temp()
        .select()
        .orderBy("bulan")
        .orderBy("insert_date")
        .toList();

    var dataWater = await Tbl_waters_temp()
        .select()
        .orderBy("bulan")
        .orderBy("insert_date")
        .toList();

    for (var e in dataElectric) {
      electrics.add(new Electric(
          unitCode: e.unit_code,
          type: "Electric",
          bulan: e.bulan,
          tahun: e.tahun,
          nomorSeri: e.nomor_seri,
          pemakaian: e.pemakaian,
          foto: e.foto,
          insertBy: e.insert_by,
          insertDate: e.insert_date));
    }
    for (var w in dataWater) {
      waters.add(new Electric(
          unitCode: w.unit_code,
          type: "Water",
          bulan: w.bulan,
          tahun: w.tahun,
          nomorSeri: w.nomor_seri,
          pemakaian: w.pemakaian,
          insertBy: w.insert_by,
          foto: w.foto,
          insertDate: w.insert_date));
    }

    dataPost.electrics = electrics;
    dataPost.waters = waters;
    getClient().synchronize(dataPost).then((res) async {
      Navigator.pop(context);
      if (res.status) {
        await Tbl_electrics_temp().select().delete();
        await Tbl_waters_temp().select().delete();
        WidgetSnackbar(
            context: context,
            message: "Successfully Upload to Server",
            warna: "hijau");
        if (dataElectric.length > 0) {
          syncElectrics();
        }
        if (dataWater.length > 0) {
          syncWaters();
        }
        currentPage(index);
      } else {
        WidgetSnackbar(
            context: context, message: "Failed to upload", warna: "merah");
      }
    }).catchError((Object obj) {
      print(obj.toString());
      Navigator.pop(context);
      WidgetSnackbar(
          context: context,
          message: "Failed connect to server!",
          warna: "merah");
    });
  }

  syncUnits() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());
    getClient().getUnits('51022').then((res) async {
      Navigator.pop(context);
      if (res.status) {
        listMkrtUnit = res.mkrtUnit;
        await Tbl_mkrt_unit().select().delete();
        final results = await Tbl_mkrt_unit().upsertAll(listMkrtUnit);
        WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
        _selectedTab(index);
      } else {
        WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
      }
      currentPage(index);
    }).catchError((Object obj) {
      print(obj.toString());
      Navigator.pop(context);
      WidgetSnackbar(
          context: context,
          message: "Failed connect to server!",
          warna: "merah");
    });
  }

  syncElectrics() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());
    getClient().getElectrics().then((res) async {
      Navigator.pop(context);
      if (res.status) {
        listElectric = res.listElectric;
        await Tbl_electric().select().delete();
        final results = await Tbl_electric().upsertAll(listElectric);
        WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
        _selectedTab(index);
      } else {
        WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
      }
      currentPage(index);
    }).catchError((Object obj) {
      print(obj.toString());
      Navigator.pop(context);
      WidgetSnackbar(
          context: context,
          message: "Failed connect to server!",
          warna: "merah");
    });
  }

  syncWaters() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());
    getClient().getWaters().then((res) async {
      Navigator.pop(context);
      if (res.status) {
        listWater = res.listWater;
        await Tbl_water().select().delete();
        final results = await Tbl_water().upsertAll(listWater);

        WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
        _selectedTab(index);
      } else {
        WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
      }
      currentPage(index);
    }).catchError((Object obj) {
      print(obj.toString());
      Navigator.pop(context);
      WidgetSnackbar(
          context: context,
          message: "Failed connect to server!",
          warna: "merah");
    });
  }

  getLocalElectric() async {
    final el = await Tbl_electrics_temp().select().toList();
    setState(() {
      countTempElectric = el.length;
      totalTemp = countTempWater + countTempElectric;
    });
  }

  getLocalWater() async {
    final wa = await Tbl_waters_temp().select().toList();
    setState(() {
      countTempWater = wa.length;
      totalTemp = countTempWater + countTempElectric;
    });
  }

  @override
  void initState() {
    super.initState();
    _permissionRequest();
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkConnection();
      getLocalElectric();
      getLocalWater();
    });
    getLocalElectric();
    getLocalWater();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 0.5, color: Colors.white, style: BorderStyle.solid),
                color: isConnect ? ColorsTheme.hijau : ColorsTheme.merah,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: PopupMenuButton(
              padding: EdgeInsets.only(top: 20),
              offset: Offset(0, SizeConfig.screenHeight * 0.02),
              onSelected: (val) {
                if (val == "Logout") {
                  displayDialog();
                } else if (val == "Upload") {
                  syncUpload();
                } else if (val == "Sync Units") {
                  syncUnits();
                } else if (val == "Sync Electrics") {
                  syncElectrics();
                } else if (val == "Sync Waters") {
                  syncWaters();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  height: SizeConfig.screenHeight * 0.05,
                  child: Badge(
                      showBadge: totalTemp == 0 ? false : true,
                      badgeContent: Text(
                        totalTemp.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      position: BadgePosition.topEnd(top: -12, end: -20),
                      child: Text("Upload")),
                  value: "Upload",
                ),
                PopupMenuItem(
                  height: SizeConfig.screenHeight * 0.05,
                  child: Text("Sync Units"),
                  value: "Sync Units",
                ),
                PopupMenuItem(
                  height: SizeConfig.screenHeight * 0.05,
                  child: Text("Sync Electrics"),
                  value: "Sync Electrics",
                ),
                PopupMenuItem(
                  height: SizeConfig.screenHeight * 0.05,
                  child: Text("Sync Waters"),
                  value: "Sync Waters",
                ),
                PopupMenuItem(
                  height: SizeConfig.screenHeight * 0.05,
                  child: Text("Logout"),
                  value: "Logout",
                ),
              ],
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: SizeConfig.screenWidth * 0.07,
              ),
            ),
          )
        ],
      ),
      body: currentPage(index),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'SCAN',
        color: ColorsTheme.primary3,
        selectedColor: ColorsTheme.primary1,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(
              iconData: Icons.electrical_services_rounded, text: 'Electic'),
          FABBottomAppBarItem(iconData: Icons.water_damage, text: 'Water'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [
      Icons.electrical_services_rounded,
      Icons.water_damage_rounded
    ];
    // return AnchoredOverlay(
    //   showOverlay: true,
    //   overlayBuilder: (context, offset) {
    //     return CenterAbout(
    //       position: Offset(offset.dx, offset.dy - icons.length * 35.0),
    //       child: FabWithIcons(
    //         icons: icons,
    //         onIconTapped: _selectedFab,
    //       ),
    //     );
    //   },
    //   child: Visibility(
    //     visible: false,
    //     child: FloatingActionButton(
    //       onPressed: () {},
    //       tooltip: 'SCAN1',
    //       child: Icon(Icons.qr_code_rounded),
    //     ),
    //   ),
    // );
    return Visibility(
      // visible: false,
      child: FloatingActionButton(
        onPressed: () {
          _selectedFab();
        },
        tooltip: 'SCAN1',
        child: Icon(Icons.qr_code_rounded),
      ),
    );
  }
}
