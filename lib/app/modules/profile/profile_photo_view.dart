import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePhotoView extends StatefulWidget {
  ProfilePhotoView(this.url, {Key? key}) : super(key: key);
  String url;
  @override
  State<ProfilePhotoView> createState() => _ProfilePhotoViewState();
}

class _ProfilePhotoViewState extends State<ProfilePhotoView> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "hero",
      child: Container(
          child: CachedNetworkImage(
        imageUrl: widget.url,
        fit: BoxFit.fitWidth,
        errorWidget: (c, s, e) => Icon(Icons.error),
      )),
    );
  }
}
