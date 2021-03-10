import 'package:easymoveinapp/style/colors.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/material.dart';

class WidgetNoData extends StatefulWidget {
  @override
  _WidgetNoDataState createState() => _WidgetNoDataState();
}

class _WidgetNoDataState extends State<WidgetNoData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      child: Center(
          child: Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 42, bottom: 42),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/no_data.png",
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text("No data",
                      style: TextStyle(
                          color: ColorsTheme.text1,
                          height: 1.1,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  SizedBox(height: 8),
                ],
              ))),
    );
  }
}
