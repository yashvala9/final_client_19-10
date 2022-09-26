import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePhotoView extends StatefulWidget {
  ProfilePhotoView(this.heroTag, this.fullname, this.url, {Key? key})
      : super(key: key);
  String url;
  String heroTag;
  String fullname;
  @override
  State<ProfilePhotoView> createState() => _ProfilePhotoViewState();
}

class _ProfilePhotoViewState extends State<ProfilePhotoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.fullname),
      ),
      body: Hero(
        tag: widget.heroTag,
        child: Center(
            child: CachedNetworkImage(
          imageUrl: widget.url,
          fit: BoxFit.fitWidth,
          errorWidget: (c, s, e) => Icon(Icons.error),
        )),
      ),
    );
  }
}
