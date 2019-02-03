import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:emrals/screens/report_detail.dart';
import 'package:emrals/models/report.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/styles.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/user.dart';

Future<List<Report>> fetchReports(http.Client client) async {
  final response = await client.get('https://www.emrals.com/api/alerts/');
  return compute(parsePhotos, response.body);
}

List<Report> parsePhotos(String responseBody) {
  var data = json.decode(responseBody);
  var parsed = data["results"] as List;
  return parsed.map<Report>((json) => Report.fromJson(json)).toList();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  int _selectedIndex = 0;
  User _userObject;

  @override
  initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    User userObject;
    var db = new DatabaseHelper();
    userObject = await db.getUser();

    if (!mounted) return;
    setState(() {
      _userObject = userObject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(_userObject.emrals.toString()),
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
      ),
      body: FutureBuilder<List<Report>>(
        future: fetchReports(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _selectedIndex,

        onTap: (index) {
          final routes = ["/home", "/camera", '/stats', '/stats'];
          Navigator.of(context)
              .pushNamedAndRemoveUntil(routes[index], (route) => false);

          setState(() {
            this._selectedIndex = index;
          });
        },
        fixedColor: Colors.red, // this will be set when a new tab is tapped

        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: new Icon(
              Icons.home,
            ),
            title: new Text('Activity'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: new Icon(
              Icons.camera,
            ),
            title: new Text('Report'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: new Icon(
              Icons.person,
            ),
            title: new Text('Stats'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: new Icon(
              Icons.person,
            ),
            title: new Text('test'),
          ),
        ],
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  PhotosList({Key key, this.photos}) : super(key: key);

  final List<Report> photos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReportDetail(report: photos[index])),
                );
              },
              child: new CachedNetworkImage(
                imageUrl: photos[index].thumbnail,
                placeholder:
                    new Image(image: AssetImage("assets/placeholder.png")),
                errorWidget: new Icon(Icons.error),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: new Container(
                      width: 77,
                      height: 77,
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          stops: [0, 0.5, 1],
                          colors: [
                            const Color(0xFF7DB208),
                            const Color(0xFFFFDC03),
                            const Color(0xFFDD26BA),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: new Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                              photos[index].posterAvatar,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    photos[index].posterUsername,
                    style: TextStyle(color: emralsColor(), fontSize: 15.0),
                  ),
                  RaisedButton(
                    color: emralsColor(),
                    disabledColor: emralsColor(),
                    highlightColor: emralsColor().shade500,
                    disabledTextColor: Colors.white,
                    textColor: Colors.white,
                    onPressed: null,
                    child: new Text("CLEAN"),
                    shape: StadiumBorder(
                      side: BorderSide(width: 2.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
