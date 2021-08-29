import 'package:flutter/material.dart';
import 'app.dart';

void main() {

  // *** Dichiarazione variabili ***
  // Inizializzazione variabili contenenti il log e la cronologia
  String status = '\n\nAPERTURA APPLICAZIONE\n\n  ';
  String cronologia = '\n\nCRONOLOGIA SITI\n\n  ';

  // Inizializzazione schermata iniziale dell'app
  runApp(App(status, cronologia));

}
