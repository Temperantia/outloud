import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/widgets/cached_image.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({@required this.imageUrl, @required this.imageRadius});

  final String imageUrl;
  final double imageRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageRadius,
      width: imageRadius,
      child: ClipOval(
        child: imageUrl == null
            ? Image.asset(
                'images/default-user-profile-image-png-7.png',
              )
            : CachedImage(
                imageUrl,
              ),
      ),
    );
  }
}
