import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Registrazione extends StatefulWidget {
  const Registrazione({Key? key}) : super(key: key);

  @override
  _RegistrazioneState createState() => _RegistrazioneState();
}

class _RegistrazioneState extends State<Registrazione> {
  final _formKey = GlobalKey<FormState>();
  final _databaseReference = FirebaseDatabase.instance.reference();
  String? _nome;
  String? _cognome;
  String? _email;
  String? _password;
  String? _nuovaPassword;
  double? _saldo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrazione'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nome = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cognome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il cognome';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cognome = value;
                },
              ),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Nuova Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci la nuova password';
                  }
                  // Aggiungi ulteriori controlli sulla nuova password se necessario.
                  return null;
                },
                onSaved: (value) {
                  _nuovaPassword = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Saldo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il saldo';
                  }
                  // Assicurati che il saldo sia un numero valido.
                  if (double.tryParse(value) == null) {
                    return 'Inserisci un valore numerico valido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _saldo = double.parse(value!);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // I dati del modulo sono validi, quindi li salviamo.
                    _formKey.currentState!.save();

                    // Scriviamo i dati nel database.
                    final userUid = _databaseReference.child('Utenti').push().key;
                    _databaseReference.child('Utenti/$userUid').set({
                      'nome': _nome,
                      'cognome': _cognome,
                      'email': _email,
                      'password': _password,
                      'nuova_password': _nuovaPassword,
                      'saldo': _saldo,
                    });

                    // Torna alla schermata principale o esegui altre azioni dopo la registrazione.
                    Navigator.pop(context);
                  }
                },
                child: Text('Registrati'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
