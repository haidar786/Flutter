import 'package:emrals/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/services.dart';

void main() {
  testWidgets('simple test', (WidgetTester tester) async {
    await tester.pumpWidget(new EmralsApp());

    Finder emailField = find.byKey(new Key('username'));
    await tester.enterText(emailField, "testing123");

    Finder passwordField = find.byKey(new Key('password'));
    await tester.enterText(passwordField, "testing123");

    expect(find.text('LOGIN'), findsOneWidget);
    var submitButton = find.text('LOGIN');
    expect(find.byType(RaisedButton), findsOneWidget);
    expect(submitButton, findsOneWidget);
  });
}
