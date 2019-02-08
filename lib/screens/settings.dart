import 'package:flutter/material.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';

class Settingg extends StatefulWidget {
  const Settingg({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<Settingg> {
  String userPicture = "https://www.emrals.com/static/images/emrals128.png";

  @override
  void initState() {
    initUser();
    super.initState();
  }

  initUser() async {
    User userObject;
    var db = DatabaseHelper();
    userObject = await db.getUser();

    if (!mounted) return;
    setState(() {
      userPicture = userObject.picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.black38),
            ),
            Positioned(
                width: 350.0,
                top: MediaQuery.of(context).size.height / 9,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(userPicture),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 20.0),
                    Text(
                      'Tom Cruise',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(33, 219, 244, 1),
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'wallet address',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      'hdsuhvuehvpsuvbwpibviowbiwort',
                      style: TextStyle(
                          fontSize: 11.0,
                          color: Color.fromRGBO(250, 250, 250, 1),
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 120.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black12,
                          color: Color.fromRGBO(164, 211, 34, 1),
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: Text(
                                'Edit Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(height: 25.0),
                    Container(
                        height: 30.0,
                        width: 120.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.black12,
                          color: Color.fromRGBO(8, 158, 178, 1),
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              var db = DatabaseHelper();
                              db.deleteUsers().then((_) {
                                Navigator.pushNamed(context, '/login');
                              });
                            },
                            child: Center(
                              child: Text(
                                'Log out',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ))
                  ],
                ))
          ],
        ));
  }
}
