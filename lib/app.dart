import 'package:flutter/material.dart';
import 'screens/home.dart';

class App extends StatelessWidget {
  App(this.status);

  String status;
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bozza Progetto',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: "Arial",
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white, fontSize: 18.0),
          headline6: TextStyle(color: Colors.red),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Bozza Progetto',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightBlue,
        ),
        body: HomePage(status),
      ),
    );
  }
}
