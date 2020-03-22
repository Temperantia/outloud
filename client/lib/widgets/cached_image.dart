import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatefulWidget {
  const CachedImage(this.url, {this.width, this.height, this.borderRadius});

  final String url;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: widget.url == null
                ? Image.asset(
                    'images/default-user-profile-image-png-7.png',
                  )
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.url,
                    placeholder: (BuildContext context, String url) =>
                        const CircularProgressIndicator(),
                    errorWidget:
                        (BuildContext context, String url, Object error) =>
                            Icon(Icons.error),
                  )));
  }
}
