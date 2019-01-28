import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchReports(http.Client client) async {
  final response = await client.get('https://www.emrals.com/api/alerts/');
  return compute(parsePhotos, response.body);
}

List<Photo> parsePhotos(String responseBody) {
  var data = json.decode(responseBody);
  var parsed = data["results"] as List;
  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int id;
  final String title;
  final String thumbnail;

  Photo({this.id, this.title, this.thumbnail});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key key }) : super(key: key);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Alerts"),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () { Navigator.pushNamed(context, '/settings'); }
            )
        ]
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchReports(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
       currentIndex: _selectedIndex,
       onTap: (index) { 
         final routes = ["/home", "/camera",'/stats'];
         print(routes[index]);
         Navigator.of(context).pushNamedAndRemoveUntil(routes[index], (route) => false);
        
         setState((){ this._selectedIndex = index; }); 
       
       },
       fixedColor: Colors.red, // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(icon: new Icon(Icons.home),title: new Text('Home')),
         BottomNavigationBarItem(icon: new Icon(Icons.camera),title: new Text('Camera')),
         //BottomNavigationBarItem(icon: new Icon(Icons.access_alarm),title: new Text('sdf')),
         BottomNavigationBarItem(icon: new Icon(Icons.person),title: new Text('Profile'))
       ],
     ),
    );
  }
}

class PhotosList extends StatelessWidget {
  PhotosList({Key key, this.photos}) : super(key: key);

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(photos[index].thumbnail),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                      child: Text(
                        photos[index].title,
                        style: TextStyle(
                            fontSize: 8.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                      child: Text(
                        photos[index].title,
                        style: TextStyle(fontSize: 8.0),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "5m",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.star_border,
                          size: 35.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 2.0,
              color: Colors.grey,
            )
          ],
        );
      },
    );
  }
}