import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';

class OpenPdf extends StatefulWidget {
  final String url;
  OpenPdf({
    Key key,
    @required this.url,
  }) : super(key: key);
  @override
  _OpenPdfState createState() => _OpenPdfState();
}

class _OpenPdfState extends State<OpenPdf> {
  FileInfo fileInfo;
  int _totalPages = 0;
  int _currentPage = 0;
  String localPath;
  PDFViewController _pdfViewController;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Read Document"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: (localPath != null)
            ? PDFView(
                fitEachPage: true,
                fitPolicy: FitPolicy.BOTH,
                pageSnap: true,
                swipeHorizontal: true,
                autoSpacing: true,
                enableSwipe: true,
                filePath: localPath,
                onError: (e) {
                  print(e);
                },
                onRender: (_pages) {
                  if (mounted)
                    setState(() {
                      _totalPages = _pages;
                    });
                },
                onViewCreated: (PDFViewController vc) {
                  _pdfViewController = vc;
                },
                onPageChanged: (int page, int total) {
                  if (mounted) setState(() {});
                },
                onPageError: (page, e) {},
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _currentPage > 0
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.red,
                  label: Text("Go to ${_currentPage - 1}"),
                  onPressed: () {
                    _currentPage -= 1;
                    _pdfViewController.setPage(_currentPage);
                  },
                )
              : Offstage(),
          _currentPage + 1 < _totalPages
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  label: Text("Go to ${_currentPage + 1}"),
                  onPressed: () {
                    _currentPage += 1;
                    _pdfViewController.setPage(_currentPage);
                  },
                )
              : Offstage(),
        ],
      ),
    );
  }
}
