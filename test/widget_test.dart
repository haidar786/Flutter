import 'package:emrals/components/animated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'AnimatedText Widget starts at zero and animates to the specified value',
      (WidgetTester tester) async {
    final int value = 100;
    await tester.pumpWidget(
      MaterialApp(
        home: AnimatedText(
          value: double.parse('$value'),
        ),
      ),
    );
    final initialValueFinder = find.text('0');
    final finalValueFinder = find.text('$value');
    expect(initialValueFinder, findsOneWidget);
    expect(finalValueFinder, findsNothing);
    await tester.pumpAndSettle();
    expect(finalValueFinder, findsOneWidget);
    expect(initialValueFinder, findsNothing);
  });
}
