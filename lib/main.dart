import 'package:cards_against_agility/models/constants.dart';
import 'package:cards_against_agility/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(CardsAgainstAgility());
}

class CardsAgainstAgility extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cards Against Agility',
      theme: ThemeData(
        primarySwatch: PRIMARY_COLOR,
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
