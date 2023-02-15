import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDPA_Widget extends StatefulWidget {
  final String path;
  const PDPA_Widget({
    Key key,
    @required this.path,
  }) : super(key: key);

  static Future<File> loadPdpa(String asset, String filename) async {
    Completer<File> completer = Completer();
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");
    var data = await rootBundle.load(asset);
    var bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
    return completer.future;
  }

  @override
  State<PDPA_Widget> createState() => _PDPA_WidgetState();
}

class _PDPA_WidgetState extends State<PDPA_Widget> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          PDFView(
            filePath: widget.path,
            fitPolicy: FitPolicy.BOTH,
            enableSwipe: true,
            swipeHorizontal: true,
            pageSnap: true,
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          
        ],
      ),
    );
  }
}
