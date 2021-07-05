import 'package:flutter/material.dart';
import 'package:progettotirocinio/screens/form_screen.dart';
import 'screens/home.dart';

class App extends StatelessWidget {
  App(this.status, this.cronologia);

  String status;
  String cronologia;
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progetto Tirocinio',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: "Arial",
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white, fontSize: 18.0),
          headline6: TextStyle(color: Colors.red),
        ),
      ),
      home: FormScreen(status, cronologia),
    );
  }
}
