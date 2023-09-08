import 'package:flutter/material.dart';


/// La classe Categorie rappresenta una categoria con un nome, un percorso dell'immagine e un colore associato.
class Categorie {
  final String nome;
  final String imagePath;
  final Color color;
  //Costruttore della classe Categorie che consente di creare un'istanza di categoria con un nome,
  // un percorso dell'immagine e un colore associato.
  Categorie({required this.nome, required this.imagePath, required this.color});
}