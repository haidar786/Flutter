import 'package:flutter/material.dart';
import 'package:emrals/routes.dart';
import 'package:emrals/styles.dart';
//import 'dart:io' show Platform;

void main() {
  //Map<String, String> envVars = Platform.environment;
  runApp(new EmralsApp());
}

class EmralsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Emrals',
      theme: new ThemeData(
        primarySwatch: emralsColor(),
        fontFamily: 'Montserrat',
      ),
      routes: routes,
    );
  }
}