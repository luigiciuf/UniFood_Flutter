import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}
//DIOSMEGMA dio bastardello aaaaasas
//mfnsjfdff
///sdsdssdsdsd
//ssss
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello world'),
        ),
      ),
    );
  }

}
