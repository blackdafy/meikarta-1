import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easymoveinapp/api/service.dart';
import 'package:easymoveinapp/models/post_qrcode.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_loading_page.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_progress.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_view_image.dart';
import 'package:easymoveinapp/main_nav.dart';
import 'package:easymoveinapp/sqlite/db.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/material.dart';
import 'package:easymoveinapp/models/res_mkrt_unit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowDataQR extends StatefulWidget {
  final Tbl_mkrt_unit res;
  final String type;
  ShowDataQR({Key key, this.res, this.type}) : super(key: key);
  @override
  _ShowDataQRState createState() => _ShowDataQRState();
}

class _ShowDataQRState extends State<ShowDataQR> {
  Tbl_mkrt_unit mkrtUnit;
  List<Electric> dataList = [];
  String sesIduser = "";
  String sesName = "";
  File fileImage;
  bool camera;
  String img64;
  String lastMeteran = "0";
  String curMonth = "";
  bool loading = true;

  TextEditingController ctrlMeteran = TextEditingController();
  TextEditingController ctrlPemakaian = TextEditingController();

  back() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainNav()),
        (Route<dynamic> route) => false);
  }

  getSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      sesIduser = preferences.getString("PREF_IDUSER");
      sesName = preferences.getString("PREF_FULLNAME");
    });
  }

  Future getImageFromCamera() async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      imageQuality: 75,
      maxHeight: 800,
    );
    final bytes = File(image.path).readAsBytesSync();
    setState(() {
      img64 = base64Encode(bytes);
      fileImage = image.renameSync(image.path);
      camera = true;
    });
  }

  Future getImageFromGallery() async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      imageQuality: 75,
      maxHeight: 800,
    );
    final bytes = File(image.path).readAsBytesSync();
    setState(() {
      img64 = base64Encode(bytes);
      fileImage = image.renameSync(image.path);
      camera = false;
    });
  }

  Future showDialogPilihan() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        child: Text(
                          "Kamera",
                        ),
                        onTap: () {
                          getImageFromCamera();
                        },
                      )),
                  SizedBox(height: 6),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        child: Text(
                          "Pilih dari Galeri",
                        ),
                        onTap: () {
                          getImageFromGallery();
                        },
                      ))
                ],
              ),
            ),
          );
        });
  }

  Future simpanServer(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());

    DateTime now = DateTime.now();
    String bulan = DateFormat('MM').format(now);
    String tahun = DateFormat('yyyy').format(now);

    ModelPostQrCode dataPost = new ModelPostQrCode();
    dataPost.unitCode = mkrtUnit.unit_code;
    dataPost.type = widget.type;
    dataPost.bulan = bulan;
    dataPost.tahun = tahun;
    dataPost.nomorSeri = ctrlMeteran.text;
    dataPost.pemakaian = ctrlPemakaian.text;
    dataPost.foto = img64;
    dataPost.insertBy = sesIduser;

    getClient().postQrCodeInput(dataPost).then((res) async {
      Navigator.pop(context);
      if (res.status) {
        WidgetSnackbar(context: context, message: res.remarks, warna: "hijau");
      } else {
        WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
      }
      goToHome();
    }).catchError((Object obj) {
      print(obj.toString());
      Navigator.pop(context);
      WidgetSnackbar(
          context: context,
          message: "Failed connect to server!",
          warna: "merah");
    });
  }

  Future simpanLocal(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());

    DateTime now = DateTime.now();
    String bulan = DateFormat('MM').format(now);
    String tahun = DateFormat('yyyy').format(now);
    String insertDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    if (widget.type.toLowerCase() == 'water') {
      var check = await Tbl_waters_temp()
          .select()
          .unit_code
          .equals(mkrtUnit.unit_code)
          .and
          .bulan
          .equals(bulan)
          .toSingle();
      if (check == null) {
        final dataSave = Tbl_waters_temp();
        dataSave.type = "Water";
        dataSave.unit_code = mkrtUnit.unit_code;
        dataSave.bulan = bulan;
        dataSave.tahun = tahun;
        dataSave.nomor_seri = ctrlMeteran.text;
        dataSave.pemakaian = ctrlPemakaian.text;
        dataSave.foto = img64;
        dataSave.insert_date = insertDate;
        dataSave.insert_by = sesIduser;
        await dataSave.save();
      } else {
        await Tbl_waters_temp()
            .select()
            .unit_code
            .equals(mkrtUnit.unit_code)
            .and
            .bulan
            .equals(bulan)
            .update({
          "nomor_seri": ctrlMeteran.text,
          "pemakaian": ctrlPemakaian.text,
          "foto": img64,
          "insert_date": insertDate,
        });
      }
    } else {
      var check = await Tbl_electrics_temp()
          .select()
          .unit_code
          .equals(mkrtUnit.unit_code)
          .and
          .bulan
          .equals(bulan)
          .toSingle();
      if (check == null) {
        final dataSave = Tbl_electrics_temp();
        dataSave.type = "Electric";
        dataSave.unit_code = mkrtUnit.unit_code;
        dataSave.bulan = bulan;
        dataSave.tahun = tahun;
        dataSave.nomor_seri = ctrlMeteran.text;
        dataSave.pemakaian = ctrlPemakaian.text;
        dataSave.foto = img64;
        dataSave.insert_date = insertDate;
        dataSave.insert_by = sesIduser;
        await dataSave.save();
      } else {
        await Tbl_electrics_temp()
            .select()
            .unit_code
            .equals(mkrtUnit.unit_code)
            .and
            .bulan
            .equals(bulan)
            .update({
          "nomor_seri": ctrlMeteran.text,
          "pemakaian": ctrlPemakaian.text,
          "foto": img64,
          "insert_date": insertDate,
        });
      }
    }
    Navigator.pop(context);
    goToHome();
    WidgetSnackbar(
        context: context,
        message: "Successfuly saving to local",
        warna: "hijau");
  }

  checkMandatory() {
    String pemakaian = ctrlPemakaian.text;
    double dPemakaian = double.parse(pemakaian);
    if (fileImage == null) {
      return "Silakan Upload Foto Meteran";
    } else if (ctrlMeteran.text.isEmpty) {
      return "Silakan isi Angka Meteran Air";
    } else if (ctrlPemakaian.text.isEmpty) {
      return "Silakan isi Pemakaian";
    } else if (dPemakaian < 0) {
      return "Pemakaian tidak boleh kurang dari 0";
    } else {
      return "";
    }
  }

  goToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainNav()),
        (Route<dynamic> route) => false);
  }

  textBulan(bulan) {
    switch (bulan) {
      case "01":
        return "Jan";
        break;
      case "02":
        return "Feb";
        break;
      case "03":
        return "Mar";
        break;
      case "04":
        return "Apr";
        break;
      case "05":
        return "May";
        break;
      case "06":
        return "Jun";
        break;
      case "07":
        return "Jul";
        break;
      case "08":
        return "Aug";
        break;
      case "09":
        return "Aug";
        break;
      case "10":
        return "Sep";
        break;
      case "11":
        return "Nov";
        break;
      case "12":
        return "Dec";
        break;
    }
  }

  Future getData() async {
    DateTime now = DateTime.now();
    // var now = new DateTime(2021, 3, 19);
    if (now.day >= 19) {
      now = new DateTime(now.year, now.month + 1, now.day);
    }
    String bulan = DateFormat('MMM').format(now);

    if (widget.type.toLowerCase() == 'water') {
      var dataWater = await Tbl_water()
          .select()
          .unit_code
          .equals(widget.res.unit_code)
          .orderBy("bulan")
          .toList();

      for (var item in dataWater) {
        dataList.add(new Electric(
          idx: item.idx,
          unitCode: item.unit_code,
          bulanText: textBulan(item.bulan),
          bulan: item.bulan,
          tahun: item.tahun,
          meteran: item.meteran,
          foto: item.foto,
          tanggalinput: item.tanggalinput,
          petugas: item.petugas,
          pemakaian: item.pemakaian,
        ));
        lastMeteran = item.meteran;
      }
    } else {
      var dataElectric = await Tbl_electric()
          .select()
          .unit_code
          .equals(widget.res.unit_code)
          .orderBy("bulan")
          .toList();

      for (var item in dataElectric) {
        dataList.add(new Electric(
          idx: item.idx,
          unitCode: item.unit_code,
          bulanText: textBulan(item.bulan),
          bulan: item.bulan,
          tahun: item.tahun,
          meteran: item.meteran,
          foto: item.foto,
          tanggalinput: item.tanggalinput,
          petugas: item.petugas,
          pemakaian: item.pemakaian,
        ));
        lastMeteran = item.meteran;
      }
    }

    setState(() {
      curMonth = bulan;
      mkrtUnit = widget.res;
      dataList = dataList;
      lastMeteran = lastMeteran;
      loading = false;
      print("=> GET DATA LOADING FALSE");
    });
  }

  @override
  void initState() {
    getData();
    getSession();
    super.initState();
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
          title: Text(widget.res.unit_code),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              back();
            },
          ),
        ),
        body: loading
            ? WidgetLoadingPage()
            : RefreshIndicator(
                // ignore: missing_return
                onRefresh: () {
                  setState(() {
                    loading = true;
                  });
                  getData();
                },
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SingleChildScrollView(
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
                                  informasiPribadiRow(
                                      "Nama",
                                      mkrtUnit.customer_name == null
                                          ? ""
                                          : mkrtUnit.customer_name),
                                  informasiPribadiRow(
                                      "Tanggal HO",
                                      mkrtUnit.date_ho == null
                                          ? ""
                                          : mkrtUnit.date_ho),
                                  informasiPribadiRow(
                                      "Tanggal MI",
                                      mkrtUnit.tanggal_dari == null
                                          ? ""
                                          : mkrtUnit.tanggal_dari)
                                ],
                              ),
                            ),
                          ),
                          headerRow(widget.type),
                          ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: dataList.length,
                              itemBuilder: (BuildContext content, int index) {
                                Electric item = dataList[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text(
                                        item.bulanText,
                                        style: TextStyle(
                                            fontSize: SizeConfig.fontSize3),
                                      ),
                                    ),
                                    detailRow(
                                        item.tanggalinput,
                                        item.petugas,
                                        item.foto,
                                        item.meteran,
                                        item.pemakaian),
                                  ],
                                );
                              }),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  "Input Data Periode " + curMonth,
                                  style:
                                      TextStyle(fontSize: SizeConfig.fontSize3),
                                ),
                              ),
                              inputRow(sesIduser, sesName),
                            ],
                          ),
                          Center(
                            child: fileImage == null
                                ?
                                //JIKA FITUR ADD (BELUM SELECT GAMBAR)
                                Container()

                                //JIKA FITUR ADD (SUDAH SELECT GAMBAR)
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(fileImage),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              width: SizeConfig.screenWidth * 1,
                              child: RaisedButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  String check = checkMandatory();
                                  if (check == "") {
                                    simpanServer(context);
                                  } else {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    WidgetSnackbar(
                                        context: context,
                                        message: check,
                                        warna: "merah");
                                  }
                                },
                                color: ColorsTheme.primary2,
                                elevation: 0,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  'SAVE TO SEVER',
                                  style:
                                      TextStyle(fontSize: SizeConfig.fontSize3),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              width: SizeConfig.screenWidth * 1,
                              child: RaisedButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  String check = checkMandatory();
                                  if (check == "") {
                                    simpanLocal(context);
                                  } else {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    WidgetSnackbar(
                                        context: context,
                                        message: check,
                                        warna: "merah");
                                  }
                                },
                                color: ColorsTheme.primary1,
                                elevation: 0,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  'SAVE TO LOCAL',
                                  style:
                                      TextStyle(fontSize: SizeConfig.fontSize3),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget informasiPribadiRow(String key, String value) {
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

  Widget headerRow(String type) {
    if (type == "Water") {
      type = "Air";
    } else {
      type = "Listrik";
    }
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.15,
            height: 35,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  "Tanggal Input",
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: 35,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  "Petugas",
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: 35,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  "Foto Meteran\n" + type,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: 35,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  "Angka Meteran\n" + type,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: 35,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  "Pemakaian",
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailRow(
    String tanggalinput,
    String petugas,
    String foto,
    String meteran,
    String pemakaian,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.15,
            height: SizeConfig.screenHeight * 0.1,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  tanggalinput,
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: SizeConfig.screenHeight * 0.1,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  petugas,
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: SizeConfig.screenHeight * 0.1,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewImage(
                                    header: "Preview",
                                    urlImage: foto,
                                  )));
                    },
                    child:
                        CachedNetworkImage(imageUrl: foto, fit: BoxFit.fill)),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: SizeConfig.screenHeight * 0.1,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  meteran,
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: SizeConfig.screenHeight * 0.1,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  pemakaian,
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputRow(String sesIduser, String sesName) {
    DateTime now = DateTime.now();
    String dateNow = DateFormat('dd-MM-yyyy').format(now);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.15,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  dateNow,
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                child: Text(
                  sesName,
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                  child: RaisedButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  showDialogPilihan();
                },
                color: ColorsTheme.primary3,
                elevation: 0,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Pilih Gambar',
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              )),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                  child: TextFormField(
                controller: ctrlMeteran,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize2,
                  height: 2.0,
                ),
                onChanged: (text) {
                  if (text == "" || text == null || text == "0") {
                    ctrlPemakaian.text = "";
                  } else {
                    double lastMeteranDouble = double.parse(lastMeteran);
                    double textDouble = double.parse(text);
                    double pemakaianDouble = textDouble - lastMeteranDouble;
                    ctrlPemakaian.text = pemakaianDouble.toString();
                  }
                },
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true, // important line
                    contentPadding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                    hintText: "Input Meteran ..."),
              )),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                left: BorderSide(color: Colors.grey),
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                  child: TextFormField(
                enabled: false,
                controller: ctrlPemakaian,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize2,
                  height: 2.0,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true, // important line
                    contentPadding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                    hintText: "Input Pemakaian ..."),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
