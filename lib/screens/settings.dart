import 'package:flutter/material.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';
import 'package:flutter/services.dart';
import 'package:emrals/styles.dart';
import 'package:intl/intl.dart';

class Settingg extends StatefulWidget {
  const Settingg({Key key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<Settingg> {
  User _userObject;
  final key = new GlobalKey<ScaffoldState>();
  final formatter = new NumberFormat("#,###");

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
      _userObject = userObject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: key,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.account_circle),
                text: 'profile',
              ),
              Tab(
                icon: Icon(Icons.archive),
                text: 'receive',
              ),
              Tab(
                icon: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(Icons.archive),
                ),
                text: 'send',
              ),
            ],
          ),
          title: Text('Settings'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                formatter.format(_userObject.emrals),
                style: TextStyle(
                  color: emralsColor(),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Image.asset("assets/JustElogo.png"),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/settings',
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Stack(
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
                                    image: NetworkImage(_userObject.picture),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(75.0)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 7.0, color: Colors.black)
                                ])),
                        SizedBox(height: 20.0),
                        Text(
                          _userObject.username,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(33, 219, 244, 1),
                              fontFamily: 'Montserrat'),
                        ),
                        SizedBox(height: 12.0),
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
            ),
            Center(
                child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),
                Text(
                  'wallet address',
                  style: TextStyle(fontSize: 17.0, fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),
                new GestureDetector(
                  child: Text(
                    _userObject.emralsAddress,
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontFamily: 'Montserrat'),
                  ),
                  onTap: () {
                    Clipboard.setData(
                      new ClipboardData(text: _userObject.emralsAddress),
                    );
                    key.currentState.showSnackBar(new SnackBar(
                      content: new Text("Copied to Clipboard"),
                    ));
                  },
                ),
                SizedBox(height: 15.0),
                Image.network(
                  'https://chart.googleapis.com/chart?cht=qr&chs=300x300&chl=' +
                      _userObject.emralsAddress,
                )
              ],
            )),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
