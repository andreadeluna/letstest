import 'package:flutter/material.dart';
import 'webview_container.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  final _linktolc =
      'https://www.cisiaonline.it/area-tematica-tolc-cisia/home-tolc-generale/';
  final _linkinvalsi = 'https://invalsi-areaprove.cineca.it/';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Center(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                //padding: EdgeInsets.all(20.0),
                child: FlatButton(
                  //color: Colors.grey,
                  //padding:
                  //EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                  onPressed: () {
                    _handleURLButtonPress(context, _linktolc);
                    Wakelock.enable();
                  },
                  child: Image.asset('images/tolc.png'),
                ),
              ),
              Expanded(
                //padding: EdgeInsets.all(20.0),
                child: FlatButton(
                  //color: Colors.grey,
                  //padding:
                  //EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                  onPressed: () {
                    _handleURLButtonPress(context, _linkinvalsi);
                    Wakelock.enable();
                  },
                  child: Image.asset('images/invalsi.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}
