import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:minimsgapp_pantaleta/Services/Auth/auth_gate.dart';
import 'package:minimsgapp_pantaleta/Themes/theme_provider.dart';
import 'package:minimsgapp_pantaleta/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
