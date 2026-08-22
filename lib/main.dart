import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const MiRutaApp());
}

class MiRutaApp extends StatelessWidget {
  const MiRutaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Ruta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
