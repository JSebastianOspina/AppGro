import 'package:appgro/screens/screens.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppGro',
      initialRoute: 'resultScreen',
      routes: {
        'homeScreen': (_) => HomeScreen(),
        'resultScreen': (_) => ResultScreen(),
        'infoScreen': (_) => InfoScreen(),
      },
    );
  }
}
