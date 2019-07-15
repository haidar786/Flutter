import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/user_profile.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:emrals/screens/settings.dart';

class ProfileDialog extends StatelessWidget {
  final int id;
  ProfileDialog({this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RestDatasource().getUser(id),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        }
        UserProfile userProfile = snapshot.data;
        return Dialog(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfilePage(
                userProfile: userProfile,
              )),
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  final UserProfile userProfile;
  ProfilePage({this.userProfile});
  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54);
    TextStyle valueStyle = TextStyle(fontSize: 24, color: emralsColor());
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          child: Container(
              margin: EdgeInsets.only(top: 25),
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                image: DecorationImage(
                    image: NetworkImage(userProfile.picture),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
              )),
        ),
        SizedBox(height: 20.0),
        Text(
          userProfile.username,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: emralsColor(),
          ),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Emrals Earned",
                  style: titleStyle,
                ),
                Text(
                  formatter.format(int.parse(
                      "${userProfile.earnedCount.isNotEmpty ? userProfile.earnedCount : 0}")),
                  style: valueStyle,
                ),
                SizedBox(height: 10),
                Text(
                  "Reports Posted",
                  style: titleStyle,
                ),
                Text(
                  formatter.format(int.parse(
                      "${userProfile.alertCount > 0 ? userProfile.alertCount : userProfile.alertCount}")),
                  style: valueStyle,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  "Emrals Donated",
                  style: titleStyle,
                ),
                Text(
                  formatter.format(int.parse(
                      "${userProfile.addedCount.isNotEmpty ? userProfile.addedCount : 0}")),
                  style: valueStyle,
                ),
                SizedBox(height: 10),
                Text(
                  "Reports Cleaned",
                  style: titleStyle,
                ),
                Text(
                  formatter.format(int.parse(
                      "${userProfile.cleanedCount > 0 ? userProfile.cleanedCount : userProfile.cleanedCount}")),
                  style: valueStyle,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton.icon(
          icon: Icon(
            Icons.add,
            color: emralsColor(),
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (ctx) => SendPage()));

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SendPage(
            //         // emralsAmount: int.tryParse(oldAmount),
            //         // key: UniqueKey(),
            //         ),
            //   ),
            // );
          },
          label: Text(
            "Send Emrals",
            style: TextStyle(color: emralsColor()),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(color: Theme.of(context).accentColor, width: 2),
          ),
          color: Colors.white,
        ),
      ],
    );
  }
}
