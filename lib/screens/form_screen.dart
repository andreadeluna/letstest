import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:progettotirocinio/screens/home.dart';

class FormScreen extends StatefulWidget {
  String status;
  String cronologia;

  FormScreen(this.status, this.cronologia);

  @override
  State<StatefulWidget> createState() {
    return FormScreenState(status, cronologia);
  }
}

class FormScreenState extends State<FormScreen> {
  String status;
  String cronologia;
  String _name;
  String _email;
  String _phonenumber;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FormScreenState(this.status, this.cronologia);

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nome e cognome'),
      //maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Il nome è richiesto';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'La mail è richiesta';
        }

        if (!RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(value)) {
          return 'Perfavore, inserire un indirizzo email valido';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Numero di telefono'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Il numero di telefono è richiesto';
        }

        return null;
      },
      onSaved: (String value) {
        _phonenumber = value;
      },
    );
  }

  @override
  String focusStat = '';

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.lightBlue[800],
          Colors.lightBlue[700],
          Colors.lightBlue[300],
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Inserimento nominativo",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 60),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.lightBlue[100],
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
                              child: Form(
                                key: _formKey,
                                child: Column(children: <Widget>[
                                  _buildName(),
                                  _buildEmail(),
                                  _buildPhoneNumber(),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }

                          _formKey.currentState.save();
                          focusStat =
                              'DATI:\nNome: $_name\nEmail: $_email\nTelefono: $_phonenumber\n\n  ';
                          status += focusStat;
                          print(_name);
                          print(_email);
                          print(_phonenumber);
                          print(status);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                  status + 'INVIO DATI\n\n  ', cronologia),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.lightBlue[900]),
                          child: Center(
                            child: Text(
                              "Invia",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
