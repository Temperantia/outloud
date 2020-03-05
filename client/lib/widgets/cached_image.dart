import 'dart:io';
import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CachedImage extends StatefulWidget {
  const CachedImage(this.url, {this.width, this.height});

  final String url;
  final double width;
  final double height;

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  Future<Widget> loadImage() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = widget.url.replaceAll('/', '-').replaceAll('.', '-');
    final File file = File(join(documentsDirectory.path, path));
    /* print('checking if file $path exists');
    if (file.existsSync()) {
      print('loading file');
      return Image(image: NetworkToFileImage(url: widget.url, file: file));
      //return Image(image: ResizeImage(MemoryImage(await file.readAsBytes())));
    } */
    return Container(
        width: widget.width,
        height: widget.height,
        child: Image(
            image: NetworkToFileImage(url: widget.url, file: file),
            fit: BoxFit.cover));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: loadImage(),
      builder: (BuildContext context, AsyncSnapshot<Widget> future) {
        return future.hasData ? future.data : Container();
      },
    );
  }
}
