import 'dart:io';
import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CachedImage extends StatefulWidget {
  const CachedImage(this.url);

  final String url;

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  Future<Widget> loadImage() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = widget.url.replaceAll('/', '-');
    final File file = File(join(documentsDirectory.path, path));
    print('checking if file exists');
    if (file.existsSync()) {
      print('loading file ' + file.path);
      return Image.file(file);
    }
    print('downloading image');
    return Image(image: NetworkToFileImage(url: widget.url, file: file));
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
