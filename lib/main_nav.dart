import 'dart:async';
import 'dart:io';

import 'package:easymoveinapp/api/service.dart';
import 'package:easymoveinapp/pages/auth/login.dart';
import 'package:easymoveinapp/pages/bottom_nav/fab_bottom_app_bar.dart';
import 'package:easymoveinapp/pages/bottom_nav/fab_with_icons.dart';
import 'package:easymoveinapp/pages/bottom_nav/layout.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/pages/qrcode/camera_scan.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:easymoveinapp/pages/menu/data_electric.dart';
import 'package:easymoveinapp/pages/menu/data_water.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _selectedFab(int ind) {
    if (permissionCamera) {
      if (ind == 0) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => WidgetCameraScan(type: "Electric")),
            (Route<dynamic> route) => false);
      } else if (ind == 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => WidgetCameraScan(type: "Water")),
            (Route<dynamic> route) => false);
      }
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

  @override
  void initState() {
    super.initState();
    _permissionRequest();
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkConnection();
    });
    getRange();
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
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  height: SizeConfig.screenHeight * 0.03,
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
          // FABBottomAppBarItem(
          //     iconData: Icons.electrical_services, text: 'Electic'),
          // FABBottomAppBarItem(iconData: Icons.water_damage, text: 'Water'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.electrical_services, Icons.water_damage];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: Visibility(
        // visible: false,
        child: FloatingActionButton(
          onPressed: () {},
          tooltip: 'SCAN1',
          child: Icon(Icons.qr_code_rounded),
        ),
      ),
    );
  }
}
