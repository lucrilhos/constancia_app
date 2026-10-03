import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/supabase_config.dart';
import 'screens/cadastro_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const ConstanciaApp());
}

class ConstanciaApp extends StatelessWidget {
  const ConstanciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Constancia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const CadastroScreen(),
    );
  }
}
