import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:thinktank/main.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mock Login and Sectionpage widgets for testing purposes
// Replace these with your actual widgets or import them if available
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Login Page')));
  }
}

class Sectionpage extends StatelessWidget {
  const Sectionpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Section Page')));
  }
}

void main() {
  final mockUser = MockUser(
    uid: '123',
    email: 'test@test.com',
  );

  testWidgets('AuthGate shows Sectionpage when signed in',
      (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);

    await tester.pumpWidget(MyApp(auth: mockAuth));

    // Wait for StreamBuilder to update UI
    await tester.pumpAndSettle();

    expect(find.text('Section Page'), findsOneWidget);
    expect(find.text('Login Page'), findsNothing);
  });

  testWidgets('AuthGate shows Login when signed out',
      (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth(signedIn: false);

    await tester.pumpWidget(MyApp(auth: mockAuth));

    await tester.pumpAndSettle();

    expect(find.text('Login Page'), findsOneWidget);
    expect(find.text('Section Page'), findsNothing);
  });
}
