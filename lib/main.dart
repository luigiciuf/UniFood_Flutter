import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unifood/firebase_options.dart';
import 'package:unifood/Registrazione.dart'; // Importa la schermata di registrazione.
import 'package:unifood/Login.dart'; // Importa la schermata di login.

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
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Al centro degli altri widget
              ElevatedButton(
                onPressed: () {
                  // Naviga alla schermata di registrazione quando il pulsante "Registrati" viene premuto.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Registrazione(),
                    ),
                  );
                },
                child: Text('Registrati'),
              ),
              SizedBox(height: 20), // Spazio tra i pulsanti
              ElevatedButton(
                onPressed: () {
                  // Naviga alla schermata di login quando il pulsante "Login" viene premuto.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
