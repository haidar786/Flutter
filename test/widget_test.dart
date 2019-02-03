import 'package:emrals/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('simple test', (WidgetTester tester) async {
    await tester.pumpWidget(new EmralsApp());
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.byType(RaisedButton), findsOneWidget);
  });
}
