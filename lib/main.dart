import 'package:beerapp/pages/login.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(const BeerApp());
}

class BeerApp extends StatelessWidget {
  // This widget is the root of your application.
  const BeerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beer app',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}