import 'package:filmin/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const FilmIn());
}

class FilmIn extends StatelessWidget {
  const FilmIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filmln',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF161E27),
      ),
      home: const LoginScreen(),
    );
  }
}