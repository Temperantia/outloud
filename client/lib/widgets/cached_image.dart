import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatefulWidget {
  const CachedImage(this.url, {this.width, this.height});

  final String url;
  final double width;
  final double height;

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        child: CachedNetworkImage(
          imageUrl: widget.url,
          placeholder: (BuildContext context, String url) =>
              const CircularProgressIndicator(),
          errorWidget: (BuildContext context, String url, Object error) =>
              Icon(Icons.error),
        ));
  }
}
