import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unifood/firebase_options.dart';
import 'package:unifood/Login.dart';
import 'package:unifood/models/Categorie.dart';
import 'package:unifood/models/Prodotto.dart';
import 'package:unifood/DatabaseManager.dart';

List<Categorie> categorie = [
  Categorie(nome: 'Pizza', imagePath: 'assets/images/cat_1.png', color: Color(0xFFfef4e5) ),
  Categorie(nome: 'Panini', imagePath: 'assets/images/cat_2.png', color: Color(0xFFf5e5fe) ),
  Categorie(nome: 'Insalate', imagePath: 'assets/images/cat_3.png', color: Color(0xFFe5f1fe) ),
  Categorie(nome: 'Bibite', imagePath: 'assets/images/cat_4.png', color: Color(0xFFebfee5) ),
  Categorie(nome: 'Dolci', imagePath: 'assets/images/cat_5.png', color: Color(0xFFf9e4e4) ),
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
                    'Benvenuto!$nomeUtente',
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
                  SizedBox(height: 20),
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
                      SizedBox(height: 20),
                      Container(
                        height: 100,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(categorie.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                filterProdottiByCategory(categorie[index].nome);
                                // Azione quando si fa clic su una categoria
                              },
                              child: Container(
                                width: 100, // Imposta una larghezza fissa
                                height: 100, // Imposta un'altezza fissa
                                margin: EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  color: categorie[index].color,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, // Centra i contenuti verticalmente
                                  children: [
                                    Image.asset(
                                      categorie[index].imagePath,
                                      width: 40, // Riduci la larghezza dell'immagine
                                      height: 40, // Riduci l'altezza dell'immagine
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4),
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
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    height: 220,
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
                                    color: Color(0xFFC51F33), // Background rosso
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
        color: Colors.grey[200],
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, // Riduce al minimo la dimensione della colonna
              children: [
                IconButton(
                  icon: Icon(Icons.checklist, color: Color(0xFFC51F33)),
                  onPressed: () {},
                ),
                Text("Lista ordini"), // Scritta sotto l'icona
              ],
            ),
            SizedBox.shrink(), // Riduce al minimo la dimensione dello SizedBox
            Column(
              mainAxisSize: MainAxisSize.min, // Riduce al minimo la dimensione della colonna
              children: [
                IconButton(
                  icon: Icon(Icons.person, color: Color(0xFFC51F33)),
                  onPressed: () {},
                ),
                Text("Profilo"), // Scritta sotto l'icona
              ],
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