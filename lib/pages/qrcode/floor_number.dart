import 'package:easymoveinapp/models/res_menus.dart';
import 'package:easymoveinapp/models/res_temp_problem.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_loading_page.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/pages/qrcode/qc_check.dart';
import 'package:easymoveinapp/pages/qrcode/reading_input.dart';
import 'package:easymoveinapp/sqlite/db.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class FloorNumber extends StatefulWidget {
  final Tbl_mkrt_unit mkrtUnit;
  final Menu menu;
  FloorNumber({Key key, this.mkrtUnit, this.menu}) : super(key: key);
  @override
  _FloorNumberState createState() => _FloorNumberState();
}

class _FloorNumberState extends State<FloorNumber> {
  bool loading = true;
  String table = '';
  String title = "";
  String blocks = "";
  String floor = "";
  String tower = "";
  String unit = "";
  List<Tbl_mkrt_unit> dataList = [];

  getData(String unit) async {
    setState(() {
      loading = true;
      dataList.clear();
    });
    final data = await DbModel().execDataTable(
        "SELECT DISTINCT mu.blocks,  mu.tower, mu.floor, mu.tipe FROM tbl_mkrt_units AS mu " +
            " WHERE mu.blocks = '" +
            widget.mkrtUnit.blocks +
            "' AND mu.tower = '" +
            widget.mkrtUnit.tower +
            "' AND mu.floor = '" +
            widget.mkrtUnit.floor +
            "' " +
            " ORDER by mu.floor ASC");
    for (var e in data) {
      dataList.add(new Tbl_mkrt_unit(
          unit_code: e['unit_code'],
          blocks: e['blocks'],
          tower: e['tower'],
          floor: e['floor'],
          tipe: e['tipe'],
          customer_name: e['customer_name'],
          customer_address: e['customer_address'],
          email: e['email'],
          electric_id: e['electric_id'],
          water_id: e['water_id'],
          phone: e['phone'],
          pppu: e['pppu'],
          date_pppu: e['date_pppu'],
          date_ho: e['date_ho'],
          eligible: e['eligible'],
          tanggal_dari: e['tanggal_dari'],
          tanggal_sampai: e['tanggal_sampai'],
          water_color: e['water_color'],
          electric_color: e['electric_color'],
          sync_date: e['sync_date']));
    }
    setState(() {
      dataList.sort((a, b) {
        return a.tipe.toLowerCase().compareTo(b.tipe.toLowerCase());
      });
      loading = false;
    });
  }

  Future<String> strResultTemp(Tbl_mkrt_unit dataList) async {
    String blocks = dataList.blocks;
    String tower = dataList.tower;
    String floor = dataList.floor;
    String tipe = dataList.tipe;
    String unit = blocks + "-" + tower + "-" + floor + "-" + floor + "" + tipe;
    List<ModelTempProblem> resData = await getDataResultTemp(unit);
    String result;
    List dataSuccess = resData.where((i) => i.problem.contains('1')).toList();
    if (resData.length > 0 && dataSuccess.length != resData.length) {
      result = '2';
    } else if (resData.length == 0) {
      result = '0';
    } else {
      result = '1';
    }
    return result;
  }

  Future<List<ModelTempProblem>> getDataResultTemp(unit) async {
    DateTime now = DateTime.now();
    if (now.day >= 19) {
      now = new DateTime(now.year, now.month + 1, now.day);
    }
    String tahun = DateFormat('y').format(now);
    String bulan = DateFormat('MM').format(now);
    List<ModelTempProblem> resData = [];
    final data = await DbModel().execDataTable("SELECT * FROM " +
        table +
        " WHERE unit_code = '" +
        unit +
        "' AND tahun = '" +
        tahun +
        "' AND bulan = '" +
        bulan +
        "' ");
    for (var i in data) {
      String problem;
      if (widget.menu.className == 'QCListrik' ||
          widget.menu.className == 'QCAir') {
        problem = i['qc_check'];
      } else {
        problem = i['problem'];
      }
      resData.add(ModelTempProblem(
        unitCode: i['unit_code'],
        tahun: i['tahun'],
        bulan: i['bulan'],
        problem: problem,
      ));
    }
    return resData;
  }

  Future<Tbl_mkrt_unit> strResult(Tbl_mkrt_unit dataList) async {
    String blocks = dataList.blocks;
    String tower = dataList.tower;
    String floor = dataList.floor;
    String tipe = dataList.tipe;
    String unit = blocks + "-" + tower + "-" + floor + "-" + floor + "" + tipe;
    Tbl_mkrt_unit resData = await getDataResult(unit);
    return resData;
  }

  Future<Tbl_mkrt_unit> getDataResult(unit) async {
    Tbl_mkrt_unit data =
        await Tbl_mkrt_unit().select().unit_code.equals(unit).toSingle();
    return data;
  }

  @override
  void initState() {
    super.initState();
    title = widget.menu.titleName;
    blocks = widget.mkrtUnit.blocks;
    tower = widget.mkrtUnit.tower;
    floor = widget.mkrtUnit.floor;
    unit = blocks + "-" + tower + "-" + floor + "-" + floor;
    getData(unit);
    if (widget.menu.className == 'QCListrik') {
      table = 'tbl_electrics_temp_qc';
    } else if (widget.menu.className == 'QCAir') {
      table = 'tbl_waters_temp_qc';
    } else if (widget.menu.className == 'ReadingListrik') {
      table = 'tbl_electrics_temp';
    } else if (widget.menu.className == 'ReadingAir') {
      table = 'tbl_waters_temp';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsTheme.primary1),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(color: ColorsTheme.primary1),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        blocks,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorsTheme.primary1,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: ColorsTheme.primary1,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            width: SizeConfig.screenWidth * 0.4,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  tower,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.05),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: ColorsTheme.primary1)),
                            width: SizeConfig.screenWidth * 0.4,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  floor,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ColorsTheme.primary1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    loading
                        ? WidgetLoadingPage()
                        : StaggeredGridView.count(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            crossAxisCount: 1,
                            mainAxisSpacing: 1,
                            physics: NeverScrollableScrollPhysics(),
                            staggeredTiles: List.generate(dataList.length,
                                (int index) => StaggeredTile.fit(1)),
                            children: List.generate(
                              dataList.length,
                              (i) {
                                print(dataList[i].toJson().toString());
                                return cardTipe(context, dataList[i],
                                    widget.menu.className);
                              },
                            ),
                          ),
                  ]))),
    );
  }

  goToCheck(
      BuildContext context, Tbl_mkrt_unit data, String param, Color bgColor) {
    if (bgColor == Colors.black) {
      WidgetSnackbar(
          context: context, message: "Unit Belum Handover", warna: "merah");
    } else {
      if (param == 'QCListrik' || param == 'QCAir') {
        if (bgColor == ColorsTheme.bgqr0 ||
            bgColor == ColorsTheme.bgqr1 ||
            bgColor == ColorsTheme.bgqr4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QCCheck(menu: widget.menu, mkrtUnit: data)));
        } else {
          WidgetSnackbar(
              context: context,
              message: "Sudah dilakukan input meteran",
              warna: "merah");
        }
      } else {
        if (bgColor == ColorsTheme.bgqr1 ||
            bgColor == ColorsTheme.bgqr2 ||
            bgColor == ColorsTheme.bgqr3) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReadingInput(menu: widget.menu, mkrtUnit: data)));
        } else {
          if (bgColor == ColorsTheme.bgqr0) {
            WidgetSnackbar(
                context: context,
                message: "Unit Belum di Check QC, harap hubungi QC",
                warna: "merah");
          } else {
            WidgetSnackbar(
                context: context,
                message: "Unit ada problem, harap hubungi QC",
                warna: "merah");
          }
        }
      }
    }
  }

  Widget cardTipe(BuildContext context, Tbl_mkrt_unit data, String param) {
    Color bgColor = Colors.black;
    Color fontColor = Colors.white;

    return FutureBuilder(
      future: Future.wait([strResultTemp(data), strResult(data)]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return WidgetLoadingPage();
        } else {
          bool isLocal = false;
          String tempData = snapshot.data[0];
          Tbl_mkrt_unit dataList = snapshot.data[1];
          print(dataList.unit_code + " == " + snapshot.data[0]);
          if (dataList.ho == '1') {
            if (tempData != '0') {
              isLocal = true;
              if (param == 'QCListrik' || param == 'QCAir') {
                if (tempData == '1') {
                  bgColor = ColorsTheme.bgqr1;
                  fontColor = Colors.black;
                } else {
                  bgColor = ColorsTheme.bgqr4;
                  fontColor = Colors.white;
                }
              } else {
                if (tempData == '1') {
                  bgColor = ColorsTheme.bgqr2;
                  fontColor = Colors.black;
                } else {
                  bgColor = ColorsTheme.bgqr3;
                  fontColor = Colors.black;
                }
              }
            } else {
              if (param == 'QCListrik') {
                if (dataList.electric == '0') {
                  bgColor = ColorsTheme.bgqr0;
                  fontColor = Colors.black;
                } else if (dataList.electric == '1') {
                  bgColor = ColorsTheme.bgqr1;
                  fontColor = Colors.black;
                } else if (dataList.electric == '2') {
                  bgColor = ColorsTheme.bgqr2;
                  fontColor = Colors.white;
                } else if (dataList.electric == '3') {
                  bgColor = ColorsTheme.bgqr3;
                  fontColor = Colors.white;
                } else if (dataList.electric == '4') {
                  bgColor = ColorsTheme.bgqr4;
                  fontColor = Colors.white;
                }
              } else if (param == 'QCAir') {
                if (dataList.water == '0') {
                  bgColor = ColorsTheme.bgqr0;
                  fontColor = Colors.black;
                } else if (dataList.water == '1') {
                  bgColor = ColorsTheme.bgqr1;
                  fontColor = Colors.black;
                } else if (dataList.water == '2') {
                  bgColor = ColorsTheme.bgqr2;
                  fontColor = Colors.white;
                } else if (dataList.water == '3') {
                  bgColor = ColorsTheme.bgqr3;
                  fontColor = Colors.white;
                } else if (dataList.water == '4') {
                  bgColor = ColorsTheme.bgqr4;
                  fontColor = Colors.white;
                }
              } else if (param == 'ReadingListrik') {
                if (dataList.electric == '0') {
                  bgColor = ColorsTheme.bgqr0;
                  fontColor = Colors.black;
                } else if (dataList.electric == '1') {
                  bgColor = ColorsTheme.bgqr1;
                  fontColor = Colors.black;
                } else if (dataList.electric == '2') {
                  bgColor = ColorsTheme.bgqr2;
                  fontColor = Colors.white;
                } else if (dataList.electric == '3') {
                  bgColor = ColorsTheme.bgqr3;
                  fontColor = Colors.white;
                } else if (dataList.electric == '4') {
                  bgColor = ColorsTheme.bgqr4;
                  fontColor = Colors.white;
                }
              } else if (param == 'ReadingAir') {
                if (dataList.water == '0') {
                  bgColor = ColorsTheme.bgqr0;
                  fontColor = Colors.black;
                } else if (dataList.water == '1') {
                  bgColor = ColorsTheme.bgqr1;
                  fontColor = Colors.black;
                } else if (dataList.water == '2') {
                  bgColor = ColorsTheme.bgqr2;
                  fontColor = Colors.white;
                } else if (dataList.water == '3') {
                  bgColor = ColorsTheme.bgqr3;
                  fontColor = Colors.white;
                } else if (dataList.water == '4') {
                  bgColor = ColorsTheme.bgqr4;
                  fontColor = Colors.white;
                }
              }
            }
          }
          return InkWell(
            onTap: () {
              goToCheck(context, data, param, bgColor);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 2,
                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(topLeft: const Radius.circular(20.0)),
                    borderRadius: BorderRadius.circular(8),
                    color: bgColor,
                  ),
                  height: SizeConfig.screenHeight * 0.1,
                  child: Stack(
                    children: [
                      isLocal
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8)),
                                  color: ColorsTheme.primary1,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    'LOCAL',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                            child: Text(
                          data.tipe,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: fontColor,
                              fontSize: SizeConfig.screenHeight * 0.04),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
