import 'package:flutter/material.dart';
import 'package:emrals/routes.dart';
import 'package:emrals/styles.dart';
//import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintLayerBordersEnabled = true;
  //debugPaintPointersEnabled = true;
  //debugPaintBaselinesEnabled = true;
  //debugRepaintRainbowEnabled = true;
  runApp(EmralsApp());
}

class EmralsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        primarySwatch: emralsColor(),
        fontFamily: 'Montserrat',
      ),
      routes: routes,
    );
  }
}
