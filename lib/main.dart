import 'package:flutter/material.dart';
import 'package:filmin/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:filmin/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://hleacgrlmrkhmvuaechi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhsZWFjZ3JsbXJraG12dWFlY2hpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAxNzgyNjIsImV4cCI6MjA1NTc1NDI2Mn0.a2hcwGotCfULOVsmdVf5o3m82nVsTAug0hpFqrgFzh0',
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
