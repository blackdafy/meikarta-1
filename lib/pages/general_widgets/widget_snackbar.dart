import 'package:easymoveinapp/style/colors.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
WidgetSnackbar({BuildContext context, String message, String warna}) {
  Color colors;
  if (warna == "merah") {
    colors = ColorsTheme.merah;
  } else if (warna == "hijau") {
    colors = ColorsTheme.hijau;
  } else if (warna == "kuning") {
    colors = ColorsTheme.kuning;
  } else {
    colors = ColorsTheme.primary1;
  }
  return Flushbar(
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.white,
    ),
    shouldIconPulse: false,
    backgroundColor: colors,
    title: "Info",
    message: message,
    duration: Duration(seconds: 5),
  )..show(context);
}
