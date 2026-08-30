import 'package:flutter/material.dart';
import 'screens/cadastro_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ConstanciaApp());
}

class ConstanciaApp extends StatelessWidget {
  const ConstanciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'constancia.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const CadastroScreen(),
    );
  }
}
