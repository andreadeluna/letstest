import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'home.dart';
import 'home.dart';

class Risultato extends StatefulWidget {
  String status;

  Risultato(this.status);

  @override
  _RisultatoState createState() => _RisultatoState(status);
}

class _RisultatoState extends State<Risultato> {
  String status;

  _RisultatoState(this.status);

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
                            builder: (context) => HomePage(status)));
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
              children: textWidgetList,
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
}
