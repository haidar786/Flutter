import 'package:flutter/material.dart';
import 'package:emrals/screens/home/home_screen.dart';
import 'package:emrals/screens/login/login_screen.dart';
import 'package:emrals/screens/settings.dart';

final routes = {
  '/login':        (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new MyHomePage(),
  '/settings':     (BuildContext context) => new Settingg(),
  '/' :            (BuildContext context) => new LoginScreen(),
};