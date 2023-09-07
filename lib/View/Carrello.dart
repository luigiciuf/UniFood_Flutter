import 'package:flutter/material.dart';
import 'package:unifood/models/Prodotto.dart';

class Carrello extends StatefulWidget {
  final List<Prodotto> carrello;

  Carrello({required this.carrello});

  @override
  _CarrelloState createState() => _CarrelloState();
}

class _CarrelloState extends State<Carrello> {
  double subtotale = 0.0; // Initialize subtotale with 0
  final double commisione = 2.0; // Fixed commisione value

  @override
  void initState() {
    super.initState();
    // Calculate the initial subtotale when the widget is created
    updateSubtotale();
  }

  // Method to calculate the subtotale
  void updateSubtotale() {
    double newSubtotale = 0.0;
    for (Prodotto prodotto in widget.carrello) {
      // Replace the comma with a period and then parse it to a double
      double prezzo = double.parse(prodotto.prezzo.replaceAll(',', '.'));
      newSubtotale += prezzo;
    }
    setState(() {
      subtotale = newSubtotale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Title
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Il mio carrello',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // List of cart items
          Expanded(
            child: ListView.builder(
              itemCount: widget.carrello.length,
              itemBuilder: (context, index) {
                Prodotto prodotto = widget.carrello[index];
                return ListTile(
                  title: Text(prodotto.nome),
                  subtitle: Text('€${prodotto.prezzo.toString()}'),
                  trailing: Image.network(prodotto.imgUri, width: 50, height: 50),
                );
              },
            ),
          ),

          // Subtotale, Commisione, and Totale
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotale:',
                      style: TextStyle(
                        color: Color(0xFF373b54),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '€${subtotale.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Color(0xFF373b54),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Commisione:',
                      style: TextStyle(
                        color: Color(0xFF373b54),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '€${commisione.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Color(0xFF373b54),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Totale:',
                      style: TextStyle(
                        color: Color(0xFF373b54),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '€',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(subtotale + commisione).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Color(0xFF373b54),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Checkout button and trash icon button
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      // Action for the "Check out" button
                    },
                    child: Text(
                      'Check out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    // Action for the trash icon button
                    setState(() {
                      widget.carrello.clear(); // Clear the cart items
                      subtotale = 0.0; // Reset subtotale
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
