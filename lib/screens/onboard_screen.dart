import 'package:emrals/main.dart';
import 'package:emrals/screens/home_screen.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(32.0),
                child: Image.asset("assets/logo.png",),
                decoration: BoxDecoration(color: emralsColor()),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Image.asset("assets/onboard_1.png"),
                        height: 125,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Report trash",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xaa000000)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Report trash from anywhere in the world",
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Clean it up",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xaa000000)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Clean it up and post a picture",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        child: Image.asset("assets/onboard_2.png"),
                        height: 125,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Image.asset("assets/onboard_3.png"),
                        height: 125,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Win EMRALS!",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xaa000000)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Win EMRALS when your cleanup is verified",
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await SimplePermissions.requestPermission(Permission.Camera);
                await SimplePermissions.requestPermission(
                    Permission.RecordAudio);
                await SimplePermissions.requestPermission(
                    Permission.AccessFineLocation);
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.setBool("onboarded", true);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (ctx) => MyHomePage()));
              },
              child: Container(
                height: 80,
                color: emralsColor(),
                child: Center(
                    child: Text(
                  "Lets Go!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
