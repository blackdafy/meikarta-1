import 'package:easymoveinapp/main_nav.dart';
import 'package:easymoveinapp/models/auth/post_model_login.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_progress.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easymoveinapp/api/service.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController ctrlUserName = new TextEditingController();
  TextEditingController ctrlPassword = new TextEditingController();
  bool isShowPass = true;

  Future submitLogin(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());
    ModelPostLogin dataSubmit = new ModelPostLogin();
    dataSubmit.email = ctrlUserName.text;
    dataSubmit.password = ctrlPassword.text;
    getClient().postLogin(dataSubmit).then((res) async {
      Navigator.pop(context);
      if (res.status) {
        pref.setString("PREF_IDUSER", res.dataUser.idUser);
        pref.setString("PREF_NICK", res.dataUser.nick);
        pref.setString("PREF_NICKNAME", res.dataUser.nickname);
        pref.setString("PREF_EMAIL", res.dataUser.email);
        pref.setString("PREF_PROFILEID", res.dataUser.profileId);
        navigateToHome();
      } else {
        WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
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

  checkMandatory() {
    if (ctrlUserName.text.isEmpty) {
      return "Silakan isi Email";
    } else if (ctrlPassword.text.isEmpty) {
      return "Silakan isi Password";
    } else {
      return "";
    }
  }

  clearPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainNav()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    clearPref();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          color: Colors.white,
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      "assets/launcher/launcher.png",
                      fit: BoxFit.cover,
                      width: SizeConfig.screenWidth * 0.7,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                  ),

                  //USERNAME FIELD
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsTheme.background2,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: SizeConfig.screenLeftRight1),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.person),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: ctrlUserName,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.01,
                  ),
                  //PASSWORD FIELD
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsTheme.background2,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: SizeConfig.screenLeftRight1),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.lock),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: ctrlPassword,
                                obscureText: isShowPass,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isShowPass = !isShowPass;
                                        });
                                      },
                                      child: Icon(
                                          !isShowPass
                                              ? CupertinoIcons.eye_solid
                                              : CupertinoIcons.eye,
                                          size: 24),
                                    ),
                                    hintText: 'Password'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: SizedBox(
                        height: SizeConfig.screenHeight * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            String check = checkMandatory();
                            if (check == "") {
                              submitLogin(context);
                            } else {
                              FocusScope.of(context).requestFocus(FocusNode());
                              WidgetSnackbar(
                                  context: context,
                                  message: check,
                                  warna: "merah");
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: ColorsTheme.primary1,
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
