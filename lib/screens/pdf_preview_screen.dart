import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';

/*
class PdfPreviewScreen extends StatelessWidget {
  final String path;

  PdfPreviewScreen({this.path});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(title: Text('Risultato')),
      path: path,
    );
  }
}
*/

class PdfPreviewScreen extends StatefulWidget {
  final String fullPath;
  PdfPreviewScreen(this.fullPath);

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState(fullPath);
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  final String fullPath;
  PDFDocument _doc;
  bool _loading = false;

  _PdfPreviewScreenState(this.fullPath);

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  _initPdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/risultatoprova.pdf");

    setState(() {
      _loading = true;
    });
    final doc = await PDFDocument.fromFile(file);
    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Risultato"),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewer(
              document: _doc,
              showPicker: false,
            ),
    );
  }
}