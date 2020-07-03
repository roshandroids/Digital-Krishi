import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class BookImage extends StatefulWidget {
  final String url;
  BookImage({@required this.url});
  @override
  _BookImageState createState() => _BookImageState();
}

class _BookImageState extends State<BookImage> {
  FileInfo fileInfo;
  bool isLoading = false;
  String localPath;

  @override
  void initState() {
    super.initState();

    loadPDF();
  }

  void loadPDF() async {
    File f = await DefaultCacheManager().getSingleFile(widget.url);

    if (mounted)
      setState(() {
        localPath = f.path;
      });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
          child: Center(
        child: (localPath != null)
            ? PdfDocumentLoader(
                filePath: localPath,
                pageNumber: 1,
              )
            : CircularProgressIndicator(),
      )),
    );
  }
}
