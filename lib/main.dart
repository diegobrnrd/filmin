import 'package:flutter/material.dart';
import 'package:filmin/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FilmIn());
  runApp(const FilmIn());
}

class FilmIn extends StatelessWidget {
  const FilmIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF161E27),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFF1F3F5),
          selectionColor: Color(0xFF208BFE),
          selectionHandleColor: Color(0xFF208BFE),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
