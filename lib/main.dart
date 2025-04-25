import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page/login.dart'; // your login page
import 'sectionpage.dart'; // your main page after login

// Define your custom darkBlue color (replace with your actual value)
const Color darkBlue = Color(0xFF001F3F);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While Firebase is still initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If the user is NOT logged in, show the Login page
        if (!snapshot.hasData || snapshot.data == null) {
          return const Login();
        }

        // If the user IS logged in, navigate to the Sectionpage
        // This ensures navigation after login without building issues
        Future.microtask(() {
          if (snapshot.hasData) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Sectionpage()),
            );
          }
        });

        // Return a placeholder widget to prevent any issues during navigation
        return const SizedBox();
      },
    );
  }
}
