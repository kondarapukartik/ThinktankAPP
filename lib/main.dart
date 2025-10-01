import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'login_page/login.dart';
import 'sectionpage.dart';

// Only import Firebase if not in CI (optional)
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color darkBlue = Color(0xFF001F3F);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Skip Firebase initialization during CI or tests
  const isCI = bool.fromEnvironment('CI');

  if (!isCI) {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // If running in CI, show a placeholder
    const isCI = bool.fromEnvironment('CI');
    if (isCI) return const Scaffold(body: SizedBox());

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Login();
        }

        Future.microtask(() {
          if (snapshot.hasData) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Sectionpage()),
            );
          }
        });

        return const SizedBox();
      },
    );
  }
}
