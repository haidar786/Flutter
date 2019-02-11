import 'package:flutter/material.dart';
import 'package:emrals/routes.dart';
import 'package:emrals/styles.dart';
import 'package:rollbar/rollbar.dart';

var rollbar =
    new Rollbar("POST_SERVER_ITEM_ACCESS_TOKEN", "flutter", "flutter");

//import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintLayerBordersEnabled = true;
  //debugPaintPointersEnabled = true;
  //debugPaintBaselinesEnabled = true;
  //debugRepaintRainbowEnabled = true;
  try {
    runApp(EmralsApp());
  } catch (error, stackTrace) {
    rollbar.trace(error, stackTrace);
  }
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
