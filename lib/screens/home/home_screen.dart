import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('https://www.emrals.com/api/alerts/');
  return compute(parsePhotos, response.body);
}

// A function that will convert a response body into a List<Photo>
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



class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts"),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
       currentIndex: _selectedIndex,
       fixedColor: Colors.red, // this will be set when a new tab is tapped
       items: [
         BottomNavigationBarItem(icon: new Icon(Icons.home),title: new Text('Home')),
         BottomNavigationBarItem(icon: new Icon(Icons.mail),title: new Text('Messages')),
         //BottomNavigationBarItem(icon: new Icon(Icons.access_alarm),title: new Text('sdf')),
         BottomNavigationBarItem(icon: new Icon(Icons.person),title: new Text('Profile'))
       ],
     ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 2,
      // ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(photos[index].thumbnail);
      },
    );


  }
}