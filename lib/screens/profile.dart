import 'package:emrals/data/rest_ds.dart';
//import 'package:emrals/models/user.dart';
//import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String id;

  Profile({this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RestDatasource().getUser(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Username'),
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
                            // image: DecorationImage(
                            //     image: NetworkImage(_userObject.picture),
                            //     fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 20.0),
                    Text(
                      "username",
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
                        "30 emrals",
                        textScaleFactor: .9,
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
