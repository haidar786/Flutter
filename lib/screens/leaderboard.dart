import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatelessWidget {
  final User currentUser;

  LeaderBoard({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RestDatasource().getAllUsers(currentUser),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> allUsers = snapshot.data;
          allUsers.sort((u1, u2) {
            if (u1.emrals > u2.emrals) return -1;
            if (u1.emrals < u2.emrals) return 1;
            if (u1.emrals == u2.emrals) return 0;
          });
          return Scaffold(
            appBar: AppBar(
              title: Text("Leaderboard"),
              bottom: PreferredSize(
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.white),
                    child: LeaderBoardListItem(
                      position: allUsers.indexOf(currentUser) + 1,
                      image: currentUser.picture,
                      name: currentUser.username,
                      score: currentUser.emrals,
                    ),
                  ),
                  preferredSize: Size.fromHeight(50)),
            ),
            body: ListView.separated(
                itemBuilder: (ctx, index) {
                  User user = allUsers[index];
                  return LeaderBoardListItem(
                    position: index + 1,
                    image: user.picture,
                    name: user.username,
                    score: user.emrals,
                    currentUser: currentUser.id == user.id,
                  );
                },
                separatorBuilder: (ctx, index) => Divider(height: 0),
                itemCount: allUsers.length),
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

class LeaderBoardListItem extends StatelessWidget {
  final int position;
  final String image;
  final String name;
  final double score;
  final bool currentUser;

  LeaderBoardListItem(
      {this.position,
      this.image,
      this.name,
      this.score,
      this.currentUser = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentUser ? emralsColor() : Colors.transparent,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            "$position",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover),
                    shape: BoxShape.circle,
                  )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "$name",
                style: TextStyle(fontSize: 20),
              ),
            ),
            flex: 3,
          ),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "$score",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20),
                ),
              )),
        ],
      ),
    );
  }
}
