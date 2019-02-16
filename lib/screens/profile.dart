import 'package:emrals/data/rest_ds.dart';
//import 'package:emrals/models/user.dart';
import 'package:emrals/models/user_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final int id;

  Profile({this.id});

  @override
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RestDatasource().getUser(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserProfile _profileObject = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(_profileObject.username),
            ),
            body: Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(color: Colors.black38),
                ),
                Center(
                    child: Column(
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(_profileObject.picture),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 20.0),
                    Text(
                      _profileObject.username,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(33, 219, 244, 1),
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 12.0),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "${_profileObject.earnedCount.isNotEmpty ? _profileObject.earnedCount : 0} emrals won",
                        textScaleFactor: 2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "${_profileObject.addedCount.isNotEmpty ? _profileObject.addedCount : 0} emrals donated",
                        textScaleFactor: 2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "${_profileObject.alertCount > 0 ? _profileObject.alertCount : _profileObject.alertCount} reports posted",
                        textScaleFactor: 2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "${_profileObject.cleanedCount > 0 ? _profileObject.cleanedCount : _profileObject.cleanedCount} reports cleaned",
                        textScaleFactor: 2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
