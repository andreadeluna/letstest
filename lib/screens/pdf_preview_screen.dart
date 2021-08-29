import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';

// Schermata di visualizzazione dell'anteprima del documento PDF
class PdfPreviewScreen extends StatefulWidget {

  // *** Dichiarazione variabili ***
  final String fullPath;

  PdfPreviewScreen(this.fullPath);

  // Definizione schermata di anteprima
  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState(fullPath);
}


// Implementazione della schermata di anteprima
class _PdfPreviewScreenState extends State<PdfPreviewScreen> {

  // *** Dichiarazione variabili ***
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


  // Widget di costruzione della schermata di anteprima del documento
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient:
            LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.lightBlue[800],
              Colors.lightBlue[700],
              Colors.lightBlue[300],
            ])),
        padding: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Anteprima PDF",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  )
                ],
              ),
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                  child: PDFViewer(
                      document: _doc,
                      showPicker: false,
                    ),
                ),
          ],
        ),
      ),
    );
  }
}
