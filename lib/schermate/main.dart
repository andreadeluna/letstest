import 'package:flutter/material.dart';
import 'splashscreen.dart';

void main() {

  // *** Dichiarazione variabili ***
  // Inizializzazione variabili contenenti il log e la cronologia
  String azioni = '\n\nAPERTURA APPLICAZIONE\n\n  ';
  String cronologia = '\n\nCRONOLOGIA SITI\n\n  ';

  // Inizializzazione schermata iniziale dell'app
  runApp(App(azioni, cronologia));

}
