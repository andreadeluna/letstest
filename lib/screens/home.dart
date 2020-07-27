import 'package:flutter/material.dart';
import 'webview_container.dart';
import 'package:wakelock/wakelock.dart';

class HomePage extends StatelessWidget {
  final _links = [
    'https://www.cisiaonline.it/area-tematica-tolc-cisia/home-tolc-generale/',
    'https://invalsi-areaprove.cineca.it/'
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _links.map((link) => _urlButton(context, link)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _urlButton(BuildContext context, String url) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: FlatButton(
        color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        child: Text('TEST'),
        onPressed: () {
          _handleURLButtonPress(context, url);
          Wakelock.enable();
        },
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}
