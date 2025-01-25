import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nagaland Lottery Results',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
       // '/details': (context) => DetailsScreen(),
      },
    );
  }
}