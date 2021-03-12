import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easymoveinapp/api/service.dart';
import 'package:easymoveinapp/models/post_qrcode.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_progress.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_snackbar.dart';
import 'package:easymoveinapp/pages/general_widgets/widget_view_image.dart';
import 'package:easymoveinapp/main_nav.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:easymoveinapp/style/size.dart';
import 'package:flutter/material.dart';
import 'package:easymoveinapp/models/res_mkrt_unit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowDataQR extends StatefulWidget {
  final ModelResponMkrtUnit res;
  final String type;
  ShowDataQR({Key key, this.res, this.type}) : super(key: key);
  @override
  _ShowDataQRState createState() => _ShowDataQRState();
}

class _ShowDataQRState extends State<ShowDataQR> {
  MkrtUnit mkrtUnit;
  List<Electric> dataList = [];
  String sesIduser = "";
  String sesName = "";
  File fileImage;
  bool camera;
  String img64;
  String lastMeteran = "0";

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

  Future simpan(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => WidgetProgressSubmit());

    DateTime now = DateTime.now();
    String bulan = DateFormat('MM').format(now);
    String tahun = DateFormat('yyyy').format(now);

    ModelPostQrCode dataPost = new ModelPostQrCode();
    dataPost.unitCode = mkrtUnit.unitCode;
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
    if (fileImage == null) {
      return "Silakan Upload Foto Meteran";
    } else if (ctrlMeteran.text.isEmpty) {
      return "Silakan isi Angka Meteran Air";
    } else if (ctrlPemakaian.text.isEmpty) {
      return "Silakan isi Pemakaian";
    } else {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    getSession();
    mkrtUnit = widget.res.mkrtUnit;
    if (widget.type.toLowerCase() == 'water') {
      dataList = widget.res.water;
      lastMeteran = widget.res.lastMeteranA;
    } else {
      dataList = widget.res.electric;
      lastMeteran = widget.res.lastMeteranE;
    }
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
        body: InkWell(
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
                          informasiPribadiRow("Nama", mkrtUnit.customerName),
                          informasiPribadiRow("Tanggal HO", mkrtUnit.dateHo),
                          informasiPribadiRow(
                              "Tanggal MI", mkrtUnit.tanggalDari),
                        ],
                      ),
                    ),
                  ),
                  headerRow(),
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
                                style:
                                    TextStyle(fontSize: SizeConfig.fontSize3),
                              ),
                            ),
                            detailRow(item.tanggalinput, item.petugas,
                                item.foto, item.meteran, item.pemakaian),
                          ],
                        );
                      }),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          "Input Data Periode " + widget.res.curMonth,
                          style: TextStyle(fontSize: SizeConfig.fontSize3),
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
                            simpan(context);
                          } else {
                            FocusScope.of(context).requestFocus(FocusNode());
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
                          'SIMPAN',
                          style: TextStyle(fontSize: SizeConfig.fontSize3),
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

  Widget headerRow() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.15,
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
                  "Foto Meteran Air",
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
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
                  "Angka Meteran Air",
                  style: TextStyle(fontSize: SizeConfig.fontSize2),
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.2,
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
                    ctrlPemakaian.text = pemakaianDouble.toStringAsPrecision(3);
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
