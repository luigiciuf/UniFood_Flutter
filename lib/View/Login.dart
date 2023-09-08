import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unifood/Controller/DatabaseManager.dart';
import 'package:unifood/View/Registrazione.dart';


  /// Definizione della classe Login utilizzata per permettere l'accesso all'utente


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}
  /// Definizione della classe di stato _LoginState
class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late DatabaseManager _databaseManager;
  String? _email;
  String? _password;
  @override
  void initState() {
    super.initState();
    _databaseManager = DatabaseManager(context); // Istanziazione nel costruttore
  }

  /// Widget per costruire l'interfaccia utente del login
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/login_v2.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildFormContent(),// Chiamata a una funzione per costruire il contenuto del modulo di login
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Funzione per costruire il contenuto del modulo di login
  List<Widget> _buildFormContent() {
    return [
      TextFormField(
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(Icons.email, color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Inserisci l\'email';
          }
          return null;
        },
        onSaved: (value) {
          _email = value;
        },
      ),
      SizedBox(height: 20.0),
      TextFormField(
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(Icons.lock, color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Inserisci la password';
          }
          return null;
        },
        onSaved: (value) {
          _password = value;
        },
        obscureText: true,
      ),
      SizedBox(height: 10.0),
      ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await _databaseManager.verifyLogin(_email!, _password!);
          }
        },
        child: Text('ACCEDI'),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFC51F33),
          onPrimary: Colors.white,
          minimumSize: Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
      ),
      SizedBox(height: 10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Non sei ancora registrato?', style: TextStyle(color: Colors.black)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Registrazione()));
            },
            child: Text(' Registrati ora', style: TextStyle(color: Color(0xFFC51F33))),
          ),
        ],
      ),
      SizedBox(height: 24.0),
    ];
  }

}