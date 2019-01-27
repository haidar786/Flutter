import 'package:flutter/material.dart';
//import 'package:emrals/auth.dart';
import 'package:emrals/routes.dart';
import 'dart:io' show Platform;

void main() {
  Map<String, String> envVars = Platform.environment;
  runApp(new LoginApp());
}

class LoginApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Emrals',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: routes,
    );
  }


}