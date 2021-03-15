import 'package:easymoveinapp/sqlite/db.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:easymoveinapp/pages/auth/splash_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(MyApp());
  await DbModel().initializeDB();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: ColorsTheme.primary1,
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: ColorsTheme.primary1),
          buttonColor: ColorsTheme.primary1,
          iconTheme: IconThemeData(color: ColorsTheme.primary1),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: ColorsTheme.primary1)),
      title: 'Easy Move In',
      home: SplashScreen(),
    );
  }
}
