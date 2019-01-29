import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:emrals/screens/report_detail.dart';
import 'package:emrals/models/report.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Alerts"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            })
      ]),
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
          final routes = ["/home", "/camera", '/stats'];
          Navigator.of(context)
              .pushNamedAndRemoveUntil(routes[index], (route) => false);

          setState(() {
            this._selectedIndex = index;
          });
        },
        fixedColor: Colors.red, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text('Home')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.camera), title: new Text('Camera')),
          //BottomNavigationBarItem(icon: new Icon(Icons.access_alarm),title: new Text('sdf')),
          BottomNavigationBarItem(
              icon: new Icon(Icons.person), title: new Text('Profile'))
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
            SizedBox(
              child: Center(
                child: Container(
                  color: Color(0xFFe0e0e0),
                  height: 8,
                  margin: EdgeInsetsDirectional.only(start: 0),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReportDetail(report: photos[index])),
                );
              },
              child: new Image.network(photos[index].thumbnail),
            ),
            new Row(
              children: <Widget>[
                new Container(
                    width: 100,
                    height: 100,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image:
                                new NetworkImage(photos[index].posterAvatar)))),
                Text('user' + photos[index].posterUsername),
                Text('row'),
              ],
            )
          ],
        );
      },
    );
  }
}
