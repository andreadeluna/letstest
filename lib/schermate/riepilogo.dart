import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wakelock/wakelock.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'scelta_portale.dart';
import 'anteprima_pdf.dart';

// Schermata di riepilogo contenente il log delle azioni compiute dall'utente
class Risultato extends StatefulWidget {
  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;

  Risultato(this.azioni, this.cronologia);

  // Definizione schermata di riepilogo
  @override
  _RisultatoState createState() => _RisultatoState(azioni, cronologia);
}

// Implementazione schermata di riepilogo
class _RisultatoState extends State<Risultato> {
  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;
  String aggiornaAzioni = '';
  String aggiornaCronologia = '';

  final pdf = pw.Document();

  List<Widget> textWidgetList = List<Widget>();

  _RisultatoState(this.azioni, this.cronologia);

  // Azione da compiere se l'utente indica di voler tornare alla schermata precedente
  Future<bool> _gestisciBackRiepilogo() {
    // Visualizzazione messaggio di alert
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 150,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                      child: Column(
                        children: [
                          Text(
                            "Attenzione",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Vuoi tornare alla home?",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -60,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 60,
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text('No', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  child: Text('Si', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    aggiornaAzioni = 'RITORNO ALLA HOMEPAGE\n\n  ';
                    azioni += aggiornaAzioni;
                    aggiornaCronologia = 'RITORNO ALLA HOMEPAGE\n\n  ';
                    cronologia += aggiornaCronologia;

                    //Accesso alla schermata iniziale (homepage)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(azioni, cronologia)));
                    Wakelock.disable();
                  },
                )
              ],
            ));
  }

  // Widget di costruzione della schermata di riepilogo
  @override
  Widget build(BuildContext context) {
    List<String> listaAzioni = azioni.split('  ');
    List<String> listaCronologia = cronologia.split('  ');

    // Generazione del log di riepilogo
    for (int i = 0; i < listaAzioni.length; i++) {
      textWidgetList.add(
        Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(left: 20),
          child: Text(
            listaAzioni[i],
            style: TextStyle(
              fontSize: 15,
              color: ((listaAzioni[i] == 'RILEVATA USCITA\n\n')
                  ? Colors.red
                  : Colors.black),
            ),
          ),
        ),
      );
    }

    // Controllo se l'utente indica di volere tornare alla schermata precedente
    return WillPopScope(
      onWillPop: _gestisciBackRiepilogo,
      child: MaterialApp(
        home: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            width: double.infinity,
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Riepilogo azioni",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 50),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListView(
                          children: [
                            Column(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: textWidgetList,
                                ),
                              ],
                              //textWidgetList,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    // Pulsante di visualizzazione anteprima documento
                    child: GestureDetector(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 80),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue[900],
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[500],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Anteprima PDF",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () async {
                        _creaDocumento(listaAzioni, listaCronologia);
                        await salvaPDF();

                        Directory directoryDocumento =
                            await getApplicationDocumentsDirectory();

                        String pathDocumento = directoryDocumento.path;

                        String pathFinale = "$pathDocumento/risultatoprova.pdf";

                        // Accesso alla schermata di visualizzazione PDF
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnteprimaDocumento(
                              pathFinale,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    // Pulsante di condivisione del documento
                    child: GestureDetector(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 80),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue[900],
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[500],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Condividi",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        condividiDocumento();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Generazione del documento PDF
  _creaDocumento(List listaAzioni, List listaCronologia) {
    // Sezione azioni compiute dall'utente
    pdf.addPage(
      pw.MultiPage(
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
                ],
              ),
            ),
            pw.Paragraph(text: listaAzioni[1]),
            pw.Header(level: 1, text: 'Dati utente'),
            pw.Paragraph(text: listaAzioni[3]),
            pw.Header(level: 1, text: 'Azioni compiute'),
            for (int i = 5; i < listaAzioni.length; i++)
              pw.Paragraph(text: listaAzioni[i]),
          ];
        },
      ),
    );

    // Sezione siti visitati dall'utente
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
          pw.Header(level: 1, text: 'Dati navigazione'),
          for (int i = 0; i < listaCronologia.length; i++)
            pw.Paragraph(text: listaCronologia[i]),
        ];
      },
    ));
  }

  // Salvataggio documento
  Future salvaPDF() async {
    Directory directoryDocumento = await getApplicationDocumentsDirectory();
    String pathDocumento = directoryDocumento.path;
    File file = File("$pathDocumento/risultatoprova.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  // Condivisione documento
  void condividiDocumento() async {
    Directory directoryDocumento = await getApplicationDocumentsDirectory();
    String pathDocumento = directoryDocumento.path;
    Share.shareFiles(['$pathDocumento/risultatoprova.pdf']);
  }
}
