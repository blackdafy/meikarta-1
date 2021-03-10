import 'package:easymoveinapp/main_nav.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/material.dart';
import 'package:easymoveinapp/models/res_mkrt_unit.dart';

class ShowDataQR extends StatefulWidget {
  final MkrtUnit mkrtUnit;
  ShowDataQR({Key key, this.mkrtUnit}) : super(key: key);
  @override
  _ShowDataQRState createState() => _ShowDataQRState();
}

class _ShowDataQRState extends State<ShowDataQR> {
  MkrtUnit mkrtUnit;

  back() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainNav()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    mkrtUnit = widget.mkrtUnit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(mkrtUnit.unitCode),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              back();
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        headerRow("Nama", mkrtUnit.customerName),
                        headerRow("Tanggal HO", mkrtUnit.dateHo),
                        headerRow("Tanggal MI", mkrtUnit.tanggalDari),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerRow(String key, String value) {
    return Row(
      children: [
        Container(
          width: SizeConfig.screenWidth * 0.3,
          child: Text(key),
          padding: EdgeInsets.only(bottom: 4),
        ),
        Text(": "),
        Expanded(child: Text(value)),
      ],
    );
  }
}
