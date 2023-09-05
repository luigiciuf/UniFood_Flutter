import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unifood/main.dart';
import 'package:unifood/Registrazione.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _databaseReference = FirebaseDatabase.instance.reference();
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Evita che la tastiera ridimensioni il contenuto
      body: Stack(
        children: [
          // Sfondo
          // Sfondo
          Image.asset('assets/images/login_v2.png', fit: BoxFit.cover, height: double.infinity, width: double.infinity),

          // Struttura della colonna per posizionare il contenuto in basso
          Column(
            children: [
              Expanded(child: Container()), // Espande e spinge il contenuto sottostante verso il basso
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildFormContent(),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

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
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _verifyLogin(_email!, _password!);
          }
        },
        child: Text('ACCEDI'),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
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
            child: Text(' Registrati ora', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      SizedBox(height: 24.0),  // Aggiungi questo per dare spazio in basso
    ];
  }

  void _verifyLogin(String email, String password) {
    _databaseReference.child('Utenti').once().then((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;
      bool accessoConsentito = false;

      if (data is Map<dynamic, dynamic>) {
        data.forEach((key, value) {
          final Map<dynamic, dynamic>? utente = value;
          if (utente != null &&
              utente['email'] == email &&
              utente['password'] == password) {
            accessoConsentito = true;
          }
        });

        if (accessoConsentito) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainApp(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email o password errate')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante l\'accesso al database')),
        );
      }
    });
  }
}
