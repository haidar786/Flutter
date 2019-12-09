import 'package:emrals/screens/login_screen.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localizations.dart';

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
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  "assets/logo.png",
                ),
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
                        height: 100,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).reportTrash,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xaa000000)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context).reportTrashAnywhere,
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
                            AppLocalizations.of(context).cleanItUp,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xaa000000)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context).cleanItUpAndPost,
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
                            AppLocalizations.of(context).earnMoney,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xaa000000)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context).earnMoneyCleaning,
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
                // await PermissionHandler().requestPermissions([
                //   PermissionGroup.camera,
                //   PermissionGroup.microphone,
                //   PermissionGroup.location
                // ]);
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                await sharedPreferences.setBool("onboarded", true);
                await Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => LoginScreen()));
              },
              child: Container(
                height: 80,
                color: emralsColor(),
                child: Center(
                    child: Text(
                  AppLocalizations.of(context).letsGo,
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
