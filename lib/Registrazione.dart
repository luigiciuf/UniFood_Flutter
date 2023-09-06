import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unifood/DatabaseManager.dart';
import 'package:unifood/Login.dart';

class Registrazione extends StatefulWidget {
  const Registrazione({Key? key}) : super(key: key);

  @override
  _RegistrazioneState createState() => _RegistrazioneState();
}

class _RegistrazioneState extends State<Registrazione> {
  late DatabaseManager _databaseManager;
  final _formKey = GlobalKey<FormState>();
  String? _nome;
  String? _cognome;
  String? _email;
  String? _password;
  String? _nuovaPassword;
  double? _saldo;

  @override
  void initState() {
    super.initState();
    _databaseManager = DatabaseManager(context); // Istanziazione nel costruttore
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Image.asset('assets/images/registrazione_v2.png', fit: BoxFit.cover, height: MediaQuery.of(context).size.height, width: double.infinity,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nome',
                            hintText: 'Nome',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                          ),
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
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Cognome',
                            hintText: 'Cognome',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                          ),
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
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.black),
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
                            labelText: 'Password',
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserisci la password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nuova Password',
                            hintText: 'Nuova Password',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserisci la nuova password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _nuovaPassword = value;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.black),
                            hintText: 'Saldo',
                            labelText: 'Saldo',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: Icon(Icons.attach_money, color: Colors.black),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Inserisci il saldo';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Inserisci un valore numerico valido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _saldo = double.parse(value!);
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                _databaseManager.addUser(
                                  nome: _nome!,
                                  cognome: _cognome!,
                                  email: _email!,
                                  password: _password!,
                                  nuovaPassword: _nuovaPassword!,
                                  saldo: _saldo!,
                                );

                                Navigator.pop(context);
                              }
                            },
                            child: Text('Registrati'),
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFFC51F33),
                                onPrimary: Colors.white,
                                minimumSize: Size(300, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.black, width: 2.0),
                                )
                            )
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Sei già registrato?', style: TextStyle(color: Colors.black)),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                              },
                              child: Text(' Accedi', style: TextStyle(color: Color(0xFFC51F33))),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}