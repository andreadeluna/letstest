import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';

// Schermata di visualizzazione dell'anteprima del documento PDF
class AnteprimaDocumento extends StatefulWidget {
  // *** Dichiarazione variabili ***
  final String fullPath;

  AnteprimaDocumento(this.fullPath);

  // Definizione schermata di anteprima
  @override
  _AnteprimaDocumentoState createState() => _AnteprimaDocumentoState(fullPath);
}

// Implementazione della schermata di anteprima
class _AnteprimaDocumentoState extends State<AnteprimaDocumento> {
  // *** Dichiarazione variabili ***
  final String pathDocumento;
  PDFDocument documento;
  bool caricamento = false;

  _AnteprimaDocumentoState(this.pathDocumento);

  @override
  void initState() {
    super.initState();
    _initPDF();
  }

  _initPDF() async {
    Directory directoryDocumento = await getApplicationDocumentsDirectory();
    String pathDocumento = directoryDocumento.path;
    File file = File("$pathDocumento/risultatoprova.pdf");

    setState(
      () {
        caricamento = true;
      },
    );

    final doc = await PDFDocument.fromFile(file);

    setState(
      () {
        documento = doc;
        caricamento = false;
      },
    );
  }

  // Widget di costruzione della schermata di anteprima del documento
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.lightBlue[800],
              Colors.lightBlue[700],
              Colors.lightBlue[300],
            ],
          ),
        ),
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
            caricamento
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: PDFViewer(
                      document: documento,
                      showPicker: false,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
