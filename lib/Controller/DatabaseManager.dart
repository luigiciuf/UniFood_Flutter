import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifood/main.dart';
import 'package:unifood/models/Prodotto.dart';
import 'package:unifood/models/User.dart';


 /// Questa classe gestisce le operazioni di lettura e scrittura del database Firebase.


class DatabaseManager {
  User? currentUser;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final BuildContext context;

  DatabaseManager(this.context);


  /// Verifica le credenziali di login dell'utente confrontandole con quelle nel database.
  /// Se l'utente viene trovato e le credenziali corrispondono, naviga alla schermata principale.
  /// @param email L'email fornita dall'utente per il login.
  /// @param password La password fornita dall'utente per il login.

  Future<void> verifyLogin(String email, String password) async {
    try {
      DatabaseEvent event = await _databaseReference.child('Utenti').once();
      final dynamic data = event.snapshot.value;

      if (data != null && data is Map) {
        // Itera tra i dati degli utenti per trovare una corrispondenza di email e password
        bool accessoConsentito = false;
        data.forEach((key, userData) async {
          if (userData['email'] == email && userData['password'] == password) {
            accessoConsentito = true;
            currentUser = User(
              id: userData['id']??'',
              nome: userData['nome'] ?? '',
              cognome: userData['cognome'] ?? '',
              email: userData['email'] ?? '',
              password: userData['password'] ?? '',
              nuovaPassword: userData['nuova_password'] ?? '',
              saldo: userData['saldo'] != null ? double.parse(userData['saldo'].toString()) : 0.0,
            );
            // Memorizza il valore dell'ID dell'utente corrente sotto la chiave 'userid' nelle SharedPreferences.
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('userid', currentUser!.id);
          }
        });

        if (accessoConsentito && currentUser != null) {
          // Memorizza l'utente corrente
          this.currentUser = currentUser;
          // Login riuscito, naviga alla schermata principale
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


/// Funzione che aggiunge un utente al database, utilizzata nella registrazione.
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
        'id': userUid,
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

  /// Funzione per ottenere la lista di prodotti dal database
  Future<List<Prodotto>> getProdotti() async {
    List<Prodotto> prodotti = [];

    try {
      DatabaseEvent event = await _databaseReference.child('Prodotti').once();
      final dynamic data = event.snapshot.value;

      if (data != null && data is Map) {
        data.forEach((key, prodottoData) {
          prodotti.add(Prodotto(
            nome: prodottoData['nome'] ?? '',
            imgUri: prodottoData['imgUri'] ?? '',
            prezzo: prodottoData['prezzo'] ?? '0,00',
            categoria: prodottoData['categoria'] ?? '',
          ));
        });
      }
    } catch (error) {
      print('Error fetching products: $error');
    }

    return prodotti;
  }
  /// Funzione per ottenere il "Primo del Giorno" dal database
  Future<String> getPrimoDelGiorno() async {
    try {
      DatabaseEvent event = await _databaseReference.child('PrimoDelGiorno').once();
      final dynamic data = event.snapshot.value;

      if (data != null) {
        return data.toString();
      } else {
        return ''; // Ritorna una stringa vuota se i dati non sono disponibili
      }
    } catch (error) {
      print('Error fetching Primo del Giorno: $error');
      return ''; // Ritorna una stringa vuota in caso di errore
    }
  }
  ///  Crea un ordine nel database Firebase a partire dalla lista di prodotti fornita.
  ///  Dopo aver inserito l'ordine con successo, svuota il carrello.
  ///  In caso di errore, mostra una SnackBar con un messaggio di errore.
  ///  * @param cartItems Articoli nel carrello dell'utente da ordinare.
  ///  Recupera le informazioni dello userid che ha creato l'ordine
  Future<void> createOrder(List<Prodotto> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userid = prefs.getString('userid') ?? '';
      // Genera un ID dell'ordine casuale da 0 a 1000
      final orderId = Random().nextInt(1001).toString();
      final orderData = {
        'userid': userid,
        'items': cartItems.map((item) {
          return {
            'nome': item.nome,
            'prezzo': item.prezzo,
            'imgUri': item.imgUri,
          };
        }).toList(),
      };
      await _databaseReference.child('Ordini').child(orderId).set(orderData);
      // Dopo aver creato l'ordine, svuota il carrello
      cartItems.clear();
    } catch (error) {
      print('Error creating order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante la creazione dell\'ordine')),
      );
    }
  }

}