import 'package:flutter/material.dart';
import 'package:filmin/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:filmin/firebase_options.dart';

Future<void> main() async {
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
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF161E27),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF208BFE),
          selectionColor: Color(0xFF208BFE),
          selectionHandleColor: Color(0xFF208BFE),
        ),
      ),
      home: const LoginScreen()
    );
  }
}
