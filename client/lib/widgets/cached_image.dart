import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum ImageType {
  User,
  Event,
}

class CachedImage extends StatefulWidget {
  const CachedImage(this.url,
      {this.width,
      this.height,
      this.borderRadius,
      @required this.imageType,
      this.fit = BoxFit.cover});

  final String url;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final ImageType imageType;
  final BoxFit fit;

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
          image = Image.asset('images/defaultUser.png', fit: widget.fit);
          break;
        case ImageType.Event:
          image = Image.asset('images/defaultEvent.png', fit: widget.fit);
          break;
      }
    } else {
      image = CachedNetworkImage(
        fit: widget.fit,
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
