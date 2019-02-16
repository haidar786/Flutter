import 'package:emrals/screens/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:emrals/screens/home_screen.dart';
import 'package:emrals/screens/login_screen.dart';
import 'package:emrals/screens/signup_screen.dart';
import 'package:emrals/screens/settings.dart';
import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/contacts.dart';
import 'package:emrals/screens/map.dart';
import 'package:emrals/screens/profile.dart';

final routes = {
  '/login': (BuildContext context) => LoginScreen(),
  '/signup': (BuildContext context) => SignupScreen(),
  '/home': (BuildContext context) => MyHomePage(),
  '/settings': (BuildContext context) => Settingg(),
  '/camera': (BuildContext context) => CameraApp(),
  '/leaderboard': (BuildContext context) => LeaderBoard(),
  '/contacts': (BuildContext context) => Contacts(),
  '/map': (BuildContext context) => MapPage(),
  '/profile': (BuildContext context) => Profile(),
  '/': (BuildContext context) => LoginScreen(),
};
