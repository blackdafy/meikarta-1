import 'package:easymoveinapp/sqlite/db.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:easymoveinapp/pages/auth/splash_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(MyApp());
  await DbModel().initializeDB();
  WidgetsFlutterBinding.ensureInitialized();
}

// void onStart() {
//   WidgetsFlutterBinding.ensureInitialized();
//   final service = FlutterBackgroundService();
//   service.onDataReceived.listen((event) {
//     if (event!["action"] == "setAsForeground") {
//       service.setForegroundMode(true);
//       return;
//     }

//     if (event["action"] == "setAsBackground") {
//       service.setForegroundMode(false);
//     }

//     if (event["action"] == "stopService") {
//       service.stopBackgroundService();
//     }
//   });

//   // bring to foreground
//   service.setForegroundMode(true);
//   Timer.periodic(Duration(seconds: 1), (timer) async {
//     if (!(await service.isServiceRunning())) timer.cancel();
//     service.setNotificationInfo(
//       title: "My App Service",
//       content: "Updated at ${DateTime.now()}",
//     );

//     service.sendData(
//       {"current_date": DateTime.now().toIso8601String()},
//     );
//   });
// }

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
