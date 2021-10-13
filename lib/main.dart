import 'package:appgro/providers/result_provider.dart';
import 'package:appgro/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ResultProvider(),
          lazy: false,
        )
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppGro',
      initialRoute: 'homeScreen',
      routes: {
        'homeScreen': (_) => HomeScreen(),
        'resultScreen': (_) => ResultScreen(),
        'infoScreen': (_) => InfoScreen(),
      },
    );
  }
}
