import 'package:cached_network_image/cached_network_image.dart';
import 'package:easymoveinapp/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ViewImage extends StatefulWidget {
  String header;
  String urlImage;
  ViewImage({Key key, this.header, this.urlImage}) : super(key: key);
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.header),
        backgroundColor: ColorsTheme.primary1,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: widget.urlImage,
            fit: BoxFit.fill,
            imageBuilder: (context, imageProvider) => PhotoView(
              imageProvider: imageProvider,
            ),
          ),
        ),
      ),
    );
  }
}
