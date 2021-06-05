import 'package:flutter/material.dart';
import 'package:progettotirocinio/screens/home.dart';

class FormScreen extends StatefulWidget {
  String status;

  FormScreen(this.status);

  @override
  State<StatefulWidget> createState() {
    return FormScreenState(status);
  }
}

class FormScreenState extends State<FormScreen> {
  String status;
  String _name;
  String _email;
  String _phonenumber;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FormScreenState(this.status);

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nome'),
      maxLength: 10,
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
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Progetto Tirocinio',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _buildName(),
                  _buildEmail(),
                  _buildPhoneNumber(),
                  SizedBox(height: 50),
                  RaisedButton(
                    child: Text(
                      'Invia',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();
                      focusStat =
                          'DATI:\nNome: $_name\nEmail: $_email\nTelefono: $_phonenumber\n\n';
                      status += focusStat;
                      print(_name);
                      print(_email);
                      print(_phonenumber);
                      print(status);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(status + 'INVIO DATI\n\n')));
                    },
                  )
                ],
              )),
        ),
      ),
    );
  }
}
