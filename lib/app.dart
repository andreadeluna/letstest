import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progettotirocinio/screens/form_screen.dart';


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
      home: SplashScreen(status, cronologia),
    );
  }
}

class SplashScreen extends StatefulWidget {
  String status;
  String cronologia;

  SplashScreen(this.status, this.cronologia);

  @override
  _SplashScreenState createState() => _SplashScreenState(status, cronologia);
}

class _SplashScreenState extends State<SplashScreen> {
  String status;
  String cronologia;

  _SplashScreenState(this.status, this.cronologia);

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FormScreen(status, cronologia)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.lightBlue,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/splash.png', height: 150),
                SizedBox(height: 40),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}