import 'dart:async';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unifood/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              printUserData(); // Chiama la funzione per leggere e stampare i dati dal database.
            },
            child: Text('Stampa Dati Utenti'),
          ),
        ),
      ),
    );
  }
}



void printUserData() {
  final databaseReference = FirebaseDatabase.instance.reference();

  databaseReference.child('Utenti/sdjsdjf/nome').once().then((DatabaseEvent event) {
    if (event.snapshot != null) {
      // Assicurati che lo snapshot non sia nullo prima di accedere a `snapshot.value`.
      print('Valore del campo "nome": ${event.snapshot!.value}');
    }
  });

}
