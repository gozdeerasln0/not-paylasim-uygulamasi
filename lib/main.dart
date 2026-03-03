import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/note_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Firebase başlat
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2) Senin mevcut local init'in (şimdilik kalsın)
  await NoteService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Not Paylaşım',
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
