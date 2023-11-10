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
        databaseURL: "https://cebuarena-database-default-rtdb.firebaseio.com/",
        appId: "1:44015113924:web:e687208c82863db5d15b91",
        messagingSenderId: "44015113924",
        projectId: "cebuarena-database",
      ),
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
