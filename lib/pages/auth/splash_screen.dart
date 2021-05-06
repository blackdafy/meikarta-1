import 'dart:async';

import 'package:easymoveinapp/api/service.dart';
import 'package:easymoveinapp/pages/menu/home.dart';
import 'package:easymoveinapp/pages/auth/login.dart';
import 'package:easymoveinapp/sqlite/db.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool ok = false;

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

  getMasterProblem() {
    getClient().getMasterProblem().then((res) async {
      if (res.status) {
        List<Tbl_master_problem> listProblem = [];
        await Tbl_master_problem().select().delete();
        final results = await Tbl_master_problem().upsertAll(listProblem);
      }
      setState(() {
        ok = true;
      });
      getData();
    });
  }

  @override
  void initState() {
    super.initState();
    getMasterProblem();
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
