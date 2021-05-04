import 'dart:async';

import 'package:easymoveinapp/pages/menu/home.dart';
import 'package:easymoveinapp/pages/auth/login.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      if (preferences.getString("PREF_IDUSER") == null ||
          preferences.getString("PREF_IDUSER").isEmpty ||
          preferences.getString("PREF_IDUSER") == "") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.screenTopBottom1,
            right: SizeConfig.screenTopBottom1),
        child: Image.asset(
          "assets/launcher/launcher.png",
          // fit: BoxFit.,
        ),
      ),
    );
  }
}
