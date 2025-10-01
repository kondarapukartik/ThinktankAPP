import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:thinktank/main.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  final mockUser = MockUser(
    uid: '123',
    email: 'test@test.com',
  );

  final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
        const MyApp()); // Replace with a MyApp version that can accept mockAuth if needed

    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
