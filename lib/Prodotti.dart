import 'package:firebase_database/firebase_database.dart';

class Product {
  final String id;
  final String nome;
  final String prezzo;
  final String imgUri;

  Product({
    required this.id,
    required this.nome,
    required this.prezzo,
    required this.imgUri,
  });

  factory Product.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> productData = snapshot.value as Map<String, dynamic>;
    return Product(
      id: snapshot.key!,
      nome: productData['nome'] ?? '',
      prezzo: productData['prezzo'] ?? '',
      imgUri: productData['imgUri'] ?? '',
    );
  }
}
