import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unifood/UserView.dart';

class DatabaseManager {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final BuildContext context;

  DatabaseManager(this.context);

  Future<void> verifyLogin(String email, String password) async {
    try {
      DatabaseEvent event = await _databaseReference.child('Utenti').once();
      final dynamic data = event.snapshot.value;

      if (data != null && data is Map) {
        // Iterate through user data to find a matching email and password
        bool accessoConsentito = false;
        data.forEach((key, userData) {
          if (userData['email'] == email && userData['password'] == password) {
            accessoConsentito = true;
          }
        });

        if (accessoConsentito) {
          // Login successful
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
          SnackBar(content: Text('Email non trovata')),
        );
      }
    } catch (error) {
      print('Error verifying login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'accesso al database')),
      );
    }
  }
}