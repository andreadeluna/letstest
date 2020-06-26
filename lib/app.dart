import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'screens/home.dart';

class App extends StatelessWidget {
  final _resumeDetectorKey = UniqueKey();
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bozza Progetto',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: "Arial",
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white, fontSize: 18.0),
          headline6: TextStyle(color: Colors.red),
        ),
      ),
      home: FocusDetector(
        key: _resumeDetectorKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Bozza Progetto'),
            backgroundColor: Colors.teal,
          ),
          body: HomePage(),
        ),
        onFocusGained: () {
          onFocus = DateTime.now();
          print('HOMEPAGE:');
          print(
              'Focus acquisito a $onFocus, equivalente a onResume o viewDidAppear');
          print('Tempo perdita focus:');
          print(onFocus.difference(lostFocus));
          Fluttertoast.showToast(
              msg: "Accesso alla Homepage",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 16.0);
        },
        onFocusLost: () {
          lostFocus = DateTime.now();
          print('HOMEPAGE:');
          print(
              'Focus perso a $lostFocus, equivalente a onPause o viewDidDisappear');
          print('Tempo mantenimento focus:');
          print(lostFocus.difference(onFocus));
        },
      ),
    );
  }
}
