import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unifood/firebase_options.dart';
import 'package:unifood/Registrazione.dart'; // Importa la schermata di registrazione.
import 'package:unifood/Login.dart';
import 'package:unifood/models/Categorie.dart'; // Importa la schermata di login.

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
                  // Add your Image here using Image.asset('path_to_your_image.png'),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cerca...',
                      prefixIcon: Icon(Icons.search),
                      // Add your search_background image as a decoration
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true, // Questo permette al ListView di funzionare all'interno di un SingleChildScrollView
                    physics: NeverScrollableScrollPhysics(), // Questo previene lo scrolling indipendente all'interno del ListView
                    itemCount: categorie.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(categorie[index].imagePath),
                        title: Text(categorie[index].nome),
                        onTap: () {
                          // Azione quando si fa clic su una categoria
                        },
                      );
                    },
                  )
                ],
              ),
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