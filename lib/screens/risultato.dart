import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wakelock/wakelock.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'home.dart';
import 'home.dart';
import 'pdf_preview_screen.dart';

class Risultato extends StatefulWidget {
  String status;
  String cronologia;

  Risultato(this.status, this.cronologia);

  @override
  _RisultatoState createState() => _RisultatoState(status, cronologia);
}

class _RisultatoState extends State<Risultato> {
  final pdf = pw.Document();
  String status;
  String cronologia;
  String prova = "Prova PDF";

  _RisultatoState(this.status, this.cronologia);

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Vuoi tornare alla Home?'),
              actions: [
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                  child: Text('Si'),
                  onPressed: () {
                    focusStat = 'RITORNO ALLA HOMEPAGE\n\n  ';
                    status += focusStat;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(status, cronologia)));
                    Wakelock.disable();
                  },
                )
              ],
            ));
  }

  List<Widget> textWidgetList = List<Widget>();

  @override
  String focusStat = '';

  Widget build(BuildContext context) {
    List<String> stato = status.split('  ');
    List<String> cronologiaweb = cronologia.split('  ');

    for (int i = 0; i < stato.length; i++) {
      textWidgetList.add(Container(
        margin: EdgeInsets.all(0),
        color: Colors.white,
        child: Center(
          child: Text(
            stato[i],
            style: TextStyle(
                fontSize: 15,
                color: ((stato[i] == 'PROBABILE USCITA ERRONEA\n\n')
                    ? Colors.red
                    : Colors.black)),
          ),
        ),
      ));
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Progetto Tirocinio'),
            backgroundColor: Colors.lightBlue,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: textWidgetList,
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.blueGrey,
                      child: Text(
                        'Preview PDF',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      onPressed: () async {
                        writeOnPdf(stato, cronologiaweb);
                        await savePdf();

                        Directory documentDirectory =
                            await getApplicationDocumentsDirectory();

                        String documentPath = documentDirectory.path;

                        String fullPath = "$documentPath/risultatoprova.pdf";
                        print(fullPath);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PdfPreviewScreen(
                                      fullPath,
                                    )));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                    onPressed: _shareContent,
                    icon: Icon(Icons.share),
                    label: Text('Condividi'))
              ],
              //textWidgetList,
              /*[
                Text(
                  'Storico azioni',
                  style: TextStyle(fontSize: 34, color: Colors.red),
                ),

              ],*/
            ),
          ),
        ),
      ),
    );
  }

  writeOnPdf(List stato, List cronologiaweb) {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text('Riepilogo azioni', textScaleFactor: 2),
                  ])),
          pw.Header(level: 1, text: 'Dati utente'),
          //for (int i = 2; i < 7; i++)
          pw.Paragraph(text: stato[1]),

          pw.Header(level: 1, text: 'Azioni compiute'),
          for (int i = 3; i < stato.length; i++) pw.Paragraph(text: stato[i]),

          // pw.Header(level: 1, text: 'Dati navigazione'),
          // for (int i = 0; i < cronologiaweb.length; i++)
          //   pw.Paragraph(text: cronologiaweb[i]),
          // Write All the paragraph in one line.
          // For clear understanding
          // here there are line breaks.
          // pw.Paragraph(text: prova),
          // pw.,
          // pw.Paragraph(text: "$status"),
          // pw.Header(level: 1, text: 'Titolo paragrafo (Cronologia)'),
          // pw.Paragraph(text: "$cronologia"),
          // pw.Paragraph(text: "Paragrafo 3"),
          // pw.Padding(padding: const pw.EdgeInsets.all(10)),
          /*pw.Table.fromTextArray(context: context, data: const <List<String>>[
            <String>['Colonna 1', 'Colonna 2'],
            <String>['1', '1'],
            <String>['2', '2'],
            <String>['3', '3'],
            <String>['4', '4'],
          ]),*/
        ];
      },
    ));

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text('Riepilogo azioni', textScaleFactor: 2),
                  ])),
          // pw.Header(level: 1, text: 'Dati utente'),
          // //for (int i = 2; i < 7; i++)
          // pw.Paragraph(text: stato[1]),
          //
          // pw.Header(level: 1, text: 'Azioni compiute'),
          // for (int i = 3; i < stato.length; i++) pw.Paragraph(text: stato[i]),

          pw.Header(level: 1, text: 'Dati navigazione'),
          for (int i = 0; i < cronologiaweb.length; i++)
            pw.Paragraph(text: cronologiaweb[i]),
          // Write All the paragraph in one line.
          // For clear understanding
          // here there are line breaks.
          // pw.Paragraph(text: prova),
          // pw.,
          // pw.Paragraph(text: "$status"),
          // pw.Header(level: 1, text: 'Titolo paragrafo (Cronologia)'),
          // pw.Paragraph(text: "$cronologia"),
          // pw.Paragraph(text: "Paragrafo 3"),
          // pw.Padding(padding: const pw.EdgeInsets.all(10)),
          /*pw.Table.fromTextArray(context: context, data: const <List<String>>[
            <String>['Colonna 1', 'Colonna 2'],
            <String>['1', '1'],
            <String>['2', '2'],
            <String>['3', '3'],
            <String>['4', '4'],
          ]),*/
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/risultatoprova.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  void _shareContent() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    Share.shareFiles(['$documentPath/risultatoprova.pdf']);
  }
}
