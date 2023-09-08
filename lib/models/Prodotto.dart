
///La classe Prodotto rappresenta un prodotto con un nome, un'immagine, una categoria e un prezzo.

class Prodotto {
  final String nome;
  final String imgUri;
  final String prezzo;
  final String categoria;
  //Costruttore della classe Prodotto che consente di creare un'istanza di prodotto con un nome,
  // un'immagine, una categoria e un prezzo
  Prodotto({required this.nome, required this.imgUri, required this.categoria, required this.prezzo});
}
