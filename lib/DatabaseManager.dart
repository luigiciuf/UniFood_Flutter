import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unifood/main.dart';
import 'package:unifood/models/Prodotto.dart';

/**
 * Classe che mi gestisce le chiamate al database e le varie funzioni
 */
class DatabaseManager {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final BuildContext context;

  DatabaseManager(this.context);
// verifica Login
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

// funzione che mi aggiunge utente al database
  Future<void> addUser({
    required String nome,
    required String cognome,
    required String email,
    required String password,
    required String nuovaPassword,
    required double saldo,
  }) async {
    try {
      final userUid = _databaseReference.child('Utenti').push().key;
      await _databaseReference.child('Utenti/$userUid').set({
        'nome': nome,
        'cognome': cognome,
        'email': email,
        'password': password,
        'nuova_password': nuovaPassword,
        'saldo': saldo,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utente aggiunto con successo')),
      );
    } catch (error) {
      print('Error adding user: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'aggiunta dell\'utente')),
      );
    }
  }

  Future<List<Prodotto>> getProdotti() async {
    List<Prodotto> prodotti = [];

    try {
      DatabaseEvent event = await _databaseReference.child('Prodotti').once();
      print(event.snapshot.value);
      final dynamic data = event.snapshot.value;

      if (data != null && data is Map) {
        data.forEach((key, prodottoData) {
          prodotti.add(Prodotto(
            nome: prodottoData['nome'] ?? '',
            imgUri: prodottoData['imgUri'] ?? '',
            prezzo: prodottoData['prezzo'] ?? '0,00',  // Se vuoi convertirlo in double, dovrai fare ulteriori modifiche
          ));
        });
      }
    } catch (error) {
      print('Error fetching products: $error');
    }

    return prodotti;
  }
}
