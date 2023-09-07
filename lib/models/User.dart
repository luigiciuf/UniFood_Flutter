class User {
  final String id;
  final String nome;
  final String cognome;
  final String email;
  final String password;
  final String nuovaPassword;
  final double saldo;

  User({
    required this.id,
    required this.nome,
    required this.cognome,
    required this.email,
    required this.password,
    required this.nuovaPassword,
    required this.saldo,
  });
}
