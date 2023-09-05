import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unifood/firebase_options.dart';
import 'package:unifood/Registrazione.dart'; // Importa la schermata di registrazione.
import 'package:unifood/Login.dart';
import 'package:unifood/models/Categorie.dart';
import 'package:unifood/models/Prodotto.dart';
import 'package:unifood/DatabaseManager.dart';// Importa la schermata di login.

List<Categorie> categorie = [
  Categorie(nome: 'Pizza', imagePath: 'assets/images/cat_1.png'),
  Categorie(nome: 'Panini', imagePath: 'assets/images/cat_2.png'),
  Categorie(nome: 'Insalate', imagePath: 'assets/images/cat_3.png'),
  Categorie(nome: 'Bibite', imagePath: 'assets/images/cat_4.png'),
  Categorie(nome: 'Dolci', imagePath: 'assets/images/cat_5.png'),

  // Aggiungi altre categorie...

];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: Login(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ciao',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Prenota subito il tuo pranzo!',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Add your Image here using Image.asset('path_to_your_image.png'),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cerca...',
                      prefixIcon: Icon(Icons.search),
                      // Add your search_background image as a decoration
                    ),
                  ),

                  SizedBox(height: 40),

                  Container(
                    height: 120, // Imposta l'altezza desiderata per il ListView orizzontale
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(categorie.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            // Azione quando si fa clic su una categoria
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: [
                                Image.asset(categorie[index].imagePath, width: 100, height: 100),
                                SizedBox(height: 4),
                                Text(
                                    categorie[index].nome,
                                  style: TextStyle(  // Aggiungi questo stile
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),  // Aggiunge spazio tra le due liste

            FutureBuilder<List<Prodotto>>(
              future: DatabaseManager(context).getProdotti(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Errore nel caricamento dei prodotti');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('Nessun prodotto disponibile');
                } else {
                  return Container(
                    margin: EdgeInsets.only(left: 40),
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.network(snapshot.data![index].imgUri, width: 100, height: 100),
                              SizedBox(height: 4),
                              Text(snapshot.data![index].nome),
                              SizedBox(height: 4),
                              Text('€${snapshot.data![index].prezzo}'),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.checklist),
              onPressed: () {},
            ),
            SizedBox(), // Placeholder for the center button
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}