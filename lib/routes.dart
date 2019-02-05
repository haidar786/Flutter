import 'package:flutter/material.dart';
import 'package:emrals/screens/home_screen.dart';
import 'package:emrals/screens/login_screen.dart';
import 'package:emrals/screens/signup_screen.dart';
import 'package:emrals/screens/settings.dart';
import 'package:emrals/screens/camera.dart';

final routes = {
  '/login': (BuildContext context) => LoginScreen(),
  '/signup': (BuildContext context) => SignupScreen(),
  '/home': (BuildContext context) => MyHomePage(),
  '/settings': (BuildContext context) => Settingg(),
  '/camera': (BuildContext context) => CameraApp(),
  '/': (BuildContext context) => LoginScreen(),
};
