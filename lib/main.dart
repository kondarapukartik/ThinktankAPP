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
  runApp(MyApp(auth: FirebaseAuth.instance));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth auth;

  const MyApp({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: AuthGate(auth: auth),
    );
  }
}

class AuthGate extends StatelessWidget {
  final FirebaseAuth auth;

  const AuthGate({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Login();
        }

        return const Sectionpage();
      },
    );
  }
}
