import 'package:capstone_web/screens/dummy.dart';
import 'package:capstone_web/screens/login/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use kIsWeb to check if the app is running on the web
  if (kIsWeb) {
    // Initialize Firebase for web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBtnQ4ekqXybSYuvPW2h_PaDCopMdKp8jM",
          authDomain: "cebuarena-database.firebaseapp.com",
          databaseURL: "https://cebuarena-database-default-rtdb.firebaseio.com",
          projectId: "cebuarena-database",
          storageBucket: "cebuarena-database.appspot.com",
          messagingSenderId: "44015113924",
          appId: "1:44015113924:web:7cbb2c5c9772b1dcd15b91",
          measurementId: "G-NSBXTQ3NFL"),
    );
  } else {
    // Initialize Firebase for mobile (iOS/Android)
    await Firebase.initializeApp();
  }

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CebuArena',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
