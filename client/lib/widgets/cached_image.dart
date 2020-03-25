import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum ImageType {
  User,
  Event,
}

class CachedImage extends StatefulWidget {
  const CachedImage(this.url,
      {this.width, this.height, this.borderRadius, @required this.imageType});

  final String url;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final ImageType imageType;

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    Widget image;

    if (widget.url == null) {
      switch (widget.imageType) {
        case ImageType.User:
          image = Image.asset('images/defaultUser.png');
          break;
        case ImageType.Event:
          image = Image.asset('images/defaultEvent.png');
          break;
      }
    } else {
      image = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: widget.url,
        placeholder: (BuildContext context, String url) =>
            const CircularProgressIndicator(),
        errorWidget: (BuildContext context, String url, Object error) =>
            Icon(Icons.error),
      );
    }

    return Container(
        width: widget.width,
        height: widget.height,
        child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: image));
  }
}
