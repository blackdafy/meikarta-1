import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../style/colors.dart';

class WidgetLoadingPage extends StatefulWidget {
  @override
  _WidgetLoadingPageState createState() => _WidgetLoadingPageState();
}

class _WidgetLoadingPageState extends State<WidgetLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 42, bottom: 42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: CupertinoActivityIndicator(),
                ),
                Text("Please wait...",
                    style: TextStyle(
                        color: ColorsTheme.text1, height: 1.1, fontSize: 14)),
                SizedBox(height: 8),
              ],
            )));
  }
}
