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
import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/stats.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double _emralsAmount = 0;
  final List<Widget> _children = [
    ReportList(),
    CameraApp(),
    Stats(),
  ];

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
      _emralsAmount = userObject.emrals;
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
              child: Text(_emralsAmount.toString()),
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
      body: _children[_selectedIndex],
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            this._selectedIndex = index;
          });
        },
        fixedColor: Colors.red,
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

  launchMaps(latitude, longitude) async {
    String googleUrl = 'comgooglemaps://?center=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }

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
              child: Stack(
                alignment: const Alignment(.9, .9),
                children: [
                  new CachedNetworkImage(
                    imageUrl: photos[index].thumbnail,
                    placeholder:
                        new Image(image: AssetImage("assets/placeholder.png")),
                    errorWidget: new Icon(Icons.error),
                  ),
                  new GestureDetector(
                    onTap: () {
                      launchMaps(
                        photos[index].latitude,
                        photos[index].longitude,
                      );

                      print("Container clicked");
                    },
                    child: new Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: new DecorationImage(
                          image: new NetworkImage(photos[index].googleURL),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(50.0)),
                        border: new Border.all(
                          color: emralsColor(),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(
                    child: Container(
                      child: RichText(
                        //textAlign: TextAlign.right,
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: photos[index].posterUsername,
                                style: TextStyle(
                                    color: emralsColor(),
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: ' reports ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: photos[index].title,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.assessment, color: emralsColor()),
                          Text('200'),
                        ],
                      ),
                      OutlineButton(
                        color: Colors.white,
                        splashColor: emralsColor(),
                        //disabledColor: emralsColor(),
                        highlightColor: emralsColor().shade700,
                        disabledTextColor: emralsColor(),
                        textColor: emralsColor(),
                        borderSide: BorderSide(
                          color: emralsColor(),
                        ),
                        onPressed: () {},
                        child: new Text("CLEAN"),
                        shape: StadiumBorder(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ReportList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FutureBuilder<List<Report>>(
        future: fetchReports(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
