import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/contacts.dart';
import 'package:emrals/screens/home_screen.dart';
import 'package:emrals/screens/leaderboard.dart';
import 'package:emrals/screens/login_screen.dart';
import 'package:emrals/screens/map.dart';
import 'package:emrals/screens/profile.dart';
import 'package:emrals/screens/settings.dart';
import 'package:emrals/screens/signup_screen.dart';
import 'package:emrals/screens/uploads.dart';
import 'package:emrals/screens/buy.dart';
import 'package:emrals/screens/send_btc.dart';
import 'package:flutter/material.dart';

final routes = {
  '/login': (BuildContext context) => LoginScreen(),
  '/signup': (BuildContext context) => SignupScreen(),
  '/home': (BuildContext context) => MyHomePage(),
  '/settings': (BuildContext context) => Settings(),
  '/camera': (BuildContext context) => ReportScreen(),
  '/leaderboard': (BuildContext context) => LeaderBoard(),
  '/contacts': (BuildContext context) => Contacts(),
  '/map': (BuildContext context) => MapPage(key: UniqueKey()),
  '/buy': (BuildContext context) => BuyEmralsScreen(),
  '/send_btc': (BuildContext context) => SendBTCScreen(key: UniqueKey()),
  '/profile': (BuildContext context) => ProfilePage(),
  '/uploads': (BuildContext context) => Uploads(),
};
