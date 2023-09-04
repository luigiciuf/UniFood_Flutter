import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unifood/main.dart';

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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci l\'email';
                  }
                  // Aggiungi ulteriori controlli sull'email se necessario.
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci la password';
                  }
                  // Aggiungi ulteriori controlli sulla password se necessario.
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // I dati del modulo sono validi, quindi li salviamo.
                    _formKey.currentState!.save();

                    // Esegui la verifica dell'accesso nel database.
                    _verifyLogin(_email!, _password!);
                  }
                },
                child: Text('Accedi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyLogin(String email, String password) {
    // Effettua la verifica dell'accesso nel database.
    // Puoi implementare la tua logica per verificare se l'email e la password corrispondono
    // a un utente nel database Firebase Realtime.

    // Esempio di verifica: Cerca l'utente nel database.
    _databaseReference.child('Utenti').once().then((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;
      if (data is Map<dynamic, dynamic>) {
        bool accessoConsentito = false;
        data.forEach((key, value) {
          final Map<dynamic, dynamic>? utente = value;
          if (utente != null &&
              utente['email'] == email &&
              utente['password'] == password) {
            // Accesso consentito, esegui le azioni desiderate.
            print('Accesso consentito');
            accessoConsentito = true;
            // Puoi aggiungere qui la navigazione a una schermata successiva.
          }
        });

        if (accessoConsentito) {
          // Accesso consentito, esegui le azioni desiderate.
          print('Accesso consentito');

          // Puoi aggiungere qui la navigazione alla schermata principale.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainApp(), // Sostituisci con il nome corretto della schermata principale.
            ),
          );
        }
      }
    });
  }
}
