import 'package:emrals/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthMock {
  AuthMock({this.userId});
  String userId;

  bool didRequestSignIn = false;
  bool didRequestCreateUser = false;
  bool didRequestLogout = false;

  Future<String> signIn(String email, String password) async {
    didRequestSignIn = true;
    return _userIdOrError();
  }

  Future<String> createUser(String email, String password) async {
    didRequestCreateUser = true;
    return _userIdOrError();
  }

  Future<String> currentUser() async {
    return _userIdOrError();
  }

  Future<void> signOut() async {
    didRequestLogout = true;
    return Future.value();
  }

  Future<String> _userIdOrError() {
    if (userId != null) {
      return Future.value(userId);
    } else {
      throw StateError('No user');
    }
  }
}

void main() {
  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(home: widget);
  }

  /* testWidgets('empty email and password doesn\'t call sign in',
      (WidgetTester tester) async {
    // builds our widget
    await tester.pumpWidget(buildTestableWidget(LoginScreen()));

    // finds the login button
    final loginBtn = find.text('LOGIN');

    // Uses a matcher to verify that the button appears exactly once
    expect(loginBtn, findsOneWidget);

    // taps the login button
    await tester.tap(loginBtn);
  }); */
}
