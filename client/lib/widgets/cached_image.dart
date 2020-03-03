import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CachedImage extends StatefulWidget {
  const CachedImage(this.url);

  final String url;

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage>
    with AutomaticKeepAliveClientMixin<CachedImage> {
  @override
  bool get wantKeepAlive => true;

  Future<Widget> loadImage() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = widget.url.replaceAll('/', '-') +
        '.png'; // TODO(me): not sure it's necessary
    final File file = File(join(documentsDirectory.path, path));

    /*  if (file.existsSync()) {
      return Image.memory(file.readAsBytesSync());
    } */

    http.Response response;
    response = await http.get(widget.url);
    if (response.statusCode != 200) {
      return Icon(Icons.close);
    }
    file.writeAsBytesSync(response.bodyBytes);

    return Image.memory(response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Widget>(
      future: loadImage(),
      builder: (BuildContext context, AsyncSnapshot<Widget> future) {
        return future.connectionState == ConnectionState.waiting
            ? const CircularProgressIndicator()
            : future.data;
      },
    );
  }
}
