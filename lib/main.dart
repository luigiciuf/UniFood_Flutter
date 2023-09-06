import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unifood/firebase_options.dart';
import 'package:unifood/Registrazione.dart';
import 'package:unifood/Login.dart';
import 'package:unifood/models/Categorie.dart';
import 'package:unifood/models/Prodotto.dart';
import 'package:unifood/DatabaseManager.dart';

List<Categorie> categorie = [
  Categorie(nome: 'Pizza', imagePath: 'assets/images/cat_1.png'),
  Categorie(nome: 'Panini', imagePath: 'assets/images/cat_2.png'),
  Categorie(nome: 'Insalate', imagePath: 'assets/images/cat_3.png'),
  Categorie(nome: 'Bibite', imagePath: 'assets/images/cat_4.png'),
  Categorie(nome: 'Dolci', imagePath: 'assets/images/cat_5.png'),
];

List<Prodotto> listaProdotti = [];
String? selectedCategory; //
String nomeUtente = '';// Aggiungi questa variabile


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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProdotti();
  }
// qui vengono inzializzate tutte le funzioni che verranno utilizzate
  void fetchProdotti() async {
    final List<Prodotto> prodotti = await DatabaseManager(context).getProdotti();
    setState(() {
      listaProdotti = prodotti;
    });
  }

  void filterProdotti(String query) {
    if (query.isEmpty) {
      // Se la barra di ricerca è vuota, mostra tutti i prodotti
      fetchProdotti();
    } else {
      List<Prodotto> filteredProdotti = listaProdotti
          .where((prodotto) => prodotto.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        listaProdotti = filteredProdotti;
      });
    }
  }
  void filterProdottiByCategory(String category) {
    setState(() {
      if (selectedCategory == category) {
        // Se la categoria selezionata è la stessa di quella già selezionata,
        // deseleziona la categoria (mostra tutti i prodotti)
        selectedCategory = '';
        fetchProdotti(); // Mostra tutti i prodotti
      } else {
        selectedCategory = category;
        List<Prodotto> filteredProdotti = listaProdotti
            .where((prodotto) => prodotto.categoria.toLowerCase() == category.toLowerCase())
            .toList();
        listaProdotti = filteredProdotti;
      }
    });
  }

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
                    'Benvenuto!,$nomeUtente',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC51F33),
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
                  TextField(
                    controller: searchController,
                    onChanged: filterProdotti, // Assicurati che filterProdotti sia la funzione che filtra i prodotti
                    decoration: InputDecoration(
                      hintText: 'Cerca...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // Quando l'icona "X" viene premuta, cancella il testo nel campo di ricerca
                          searchController.clear();
                          // Chiamiamo la funzione di filtro per mostrare nuovamente tutti i prodotti
                          filterProdotti('');
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 130,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE28F99),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Primo Del Giorno:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'Categorie',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 120,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(categorie.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                filterProdottiByCategory(categorie[index].nome);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(categorie[index].imagePath, width: 100, height: 100),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 0),
                                      child: Text(
                                        categorie[index].nome,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      'Prodotti',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listaProdotti.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Nome del prodotto
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    listaProdotti[index].nome,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Immagine del prodotto
                                Image.network(
                                  listaProdotti[index].imgUri,
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(height: 4),
                                // Prezzo del prodotto
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    '€${listaProdotti[index].prezzo}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // "Button" Dettagli
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red, // Background rosso
                                    borderRadius: BorderRadius.circular(15), // Angoli arrotondati
                                  ),
                                  child: Text(
                                    'Dettagli', // Scritta "Dettagli"
                                    style: TextStyle(
                                      color: Colors.white, // Scritta bianca
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,// Dimensione del testo
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
            SizedBox(),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFC51F33),
        child: Icon(Icons.shopping_cart),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}