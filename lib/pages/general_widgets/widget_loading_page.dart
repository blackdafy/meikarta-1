import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../../style/colors.dart';

class WidgetLoadingPage extends StatefulWidget {
  @override
  _WidgetLoadingPageState createState() => _WidgetLoadingPageState();
}

class _WidgetLoadingPageState extends State<WidgetLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: NutsActivityIndicator(
              radius: 15,
              activeColor: ColorsTheme.primary1,
              inactiveColor: ColorsTheme.primary2,
              tickCount: 11,
              startRatio: 0.55,
              animationDuration: Duration(milliseconds: 123),
            ),
          ),
          Text("Please wait...",
              style: TextStyle(
                  color: ColorsTheme.text1, height: 1.1, fontSize: 14)),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
