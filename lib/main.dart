import 'package:flutter/material.dart';
import 'package:emrals/routes.dart';
import 'package:emrals/styles.dart';

void main() {
  runApp(new EmralsApp());
}

class EmralsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.black,
        primarySwatch: emralsColor(),
        fontFamily: 'Montserrat',
      ),
      routes: routes,
    );
  }
}
