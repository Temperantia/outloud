import 'package:flutter/material.dart';
import 'package:inclusive/widgets/circular_image.dart';

class ImageStack extends StatelessWidget {
  const ImageStack({
    Key key,
    @required this.imageList,
    this.imageRadius = 25,
    this.imageCount = 3,
    @required this.totalCount,
    this.imageBorderWidth = 2,
    this.imageBorderColor = Colors.grey,
    this.extraCountTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.backgroundColor = Colors.white,
  })  : assert(imageList != null),
        assert(extraCountTextStyle != null),
        assert(imageBorderColor != null),
        assert(backgroundColor != null),
        assert(totalCount != null),
        super(key: key);

  final List<String> imageList;
  final double imageRadius;
  final int imageCount;
  final int totalCount;
  final double imageBorderWidth;
  final Color imageBorderColor;
  final TextStyle extraCountTextStyle;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final List<Widget> images = <Widget>[];
    int _size = imageCount;
    if (imageList.isNotEmpty) {
      images
          .add(CircularImage(imageRadius: imageRadius, imageUrl: imageList[0]));
    }

    if (imageList.length > 1) {
      if (imageList.length < _size) {
        _size = imageList.length;
      }
      images.addAll(imageList
          .sublist(1, _size)
          .asMap()
          .map((int index, String image) => MapEntry<int, Positioned>(
                index,
                Positioned(
                  right: 0.8 * imageRadius * (index + 1.0),
                  child:
                      CircularImage(imageRadius: imageRadius, imageUrl: image),
                ),
              ))
          .values
          .toList());
    }
    return Container(
      child: Row(
        children: <Widget>[
          if (images.isNotEmpty)
            Stack(
              overflow: Overflow.visible,
              textDirection: TextDirection.rtl,
              children: images,
            )
          else
            const SizedBox(),
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: totalCount - images.length > 0
                ? Container(
                    constraints: BoxConstraints(minWidth: imageRadius),
                    padding: const EdgeInsets.all(3),
                    height: imageRadius,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageRadius),
                        border: Border.all(
                            color: imageBorderColor, width: imageBorderWidth),
                        color: backgroundColor),
                    child: Center(
                      child: Text(
                        (totalCount - images.length).toString(),
                        textAlign: TextAlign.center,
                        style: extraCountTextStyle,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
