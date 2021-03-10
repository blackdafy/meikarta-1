import 'package:easymoveinapp/pages/bottom_nav/fab_bottom_app_bar.dart';
import 'package:easymoveinapp/pages/bottom_nav/fab_with_icons.dart';
import 'package:easymoveinapp/pages/bottom_nav/layout.dart';
import 'package:easymoveinapp/pages/qrcode/camera_scan.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:easymoveinapp/pages/menu/data_electric.dart';
import 'package:easymoveinapp/pages/menu/data_water.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
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

  @override
  void initState() {
    super.initState();
    _permissionRequest();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
              iconData: Icons.electrical_services, text: 'Electic'),
          FABBottomAppBarItem(iconData: Icons.water_damage, text: 'Water'),
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
      child: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Scan',
        child: Icon(Icons.add),
      ),
    );
  }
}
