import 'package:flutter/material.dart';
import 'screens/principal_screen.dart';
import 'screens/escribir_screen.dart';
import 'screens/editar_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartas App',
      initialRoute: '/',
      routes: {
        '/': (context) => PrincipalScreen(),
        '/escribir': (context) => EscribirScreen(),
        '/editar': (context) => EditarScreen(),
      },
    );
  }
}
