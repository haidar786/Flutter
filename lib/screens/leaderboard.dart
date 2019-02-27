import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/profile.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatelessWidget {
  final User currentUser;

  LeaderBoard({this.currentUser});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Leaderboard"),
          bottom: TabBar(tabs: [
            Tab(
              text: "Top Reporters",
            ),
            Tab(
              text: "Top Cleaners",
            ),
          ]),
        ),
        body: TabBarView(children: [
          LeaderboardSubPage(
            leaderboardType: LeaderboardType.REPORTS,
            currentUser: currentUser,
          ),
          LeaderboardSubPage(
            leaderboardType: LeaderboardType.CLEANUPS,
            currentUser: currentUser,
          )
        ]),
      ),
    );
  }
}

class LeaderboardSubPage extends StatelessWidget {
  final LeaderboardType leaderboardType;
  final User currentUser;

  LeaderboardSubPage({this.leaderboardType, this.currentUser});

  @override
  Widget build(BuildContext context) {
    String type =
        leaderboardType == LeaderboardType.REPORTS ? "creator" : "closer";
    return FutureBuilder(
      future: leaderboardType == LeaderboardType.REPORTS
          ? RestDatasource().getLeaderboardReports()
          : RestDatasource().getLeaderboardCleanups(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> users = List.castFrom(snapshot.data);
          users.sort((u1, u2) {
            return u2["count"] - u1["count"];
          });
          return Column(
            children: <Widget>[
              // Container(
              //   decoration: BoxDecoration(color: Colors.black12),
              //   child: Builder(builder: (ctx) {
              //     if (users.firstWhere(
              //             (d) => d["${type}__id"] == currentUser.id,
              //         orElse: () => null) != null) {
              //       Map<String, dynamic> userMap = users
              //           .firstWhere((d) => d["${type}__id"] == currentUser.id);
              //       return LeaderBoardListItem(
              //         image: currentUser.picture,
              //         name: currentUser.username,
              //         position: users.indexOf(userMap) + 1,
              //         score: userMap["csount"],
              //       );
              //     } else {
              //       return Container();
              //     }
              //   }),
              // ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    Map<String, dynamic> user = users[index];
                    String image =
                        "https://www.gravatar.com/avatar/b9ce7b4f4ed21593fc1a04f09b5561a2?s=100";
                    if (user["${type}__userprofile__avatar"]
                        .toString()
                        .isNotEmpty) {
                      image =
                          "https://emfiles.storage.googleapis.com/${user["${type}__userprofile__avatar"]}";
                    }
                    return LeaderBoardListItem(
                      position: index + 1,
                      image: image,
                      name: user["${type}__username"],
                      score: (user["count"] as int),
                      currentUser: user["${type}__id"] == currentUser.id,
                      userId: user["${type}__id"],
                    );
                  },
                  itemCount: users.length,
                  shrinkWrap: true,
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class LeaderBoardListItem extends StatelessWidget {
  final int position;
  final String image;
  final String name;
  final int score;
  final bool currentUser;
  final int userId;

  LeaderBoardListItem(
      {this.position,
      this.image,
      this.name,
      this.score,
      this.userId,
      this.currentUser = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (userId != null)
          showDialog(context: context, builder: (ctx) => ProfileDialog(id: userId,));
      },
      child: Container(
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
      ),
    );
  }
}

enum LeaderboardType { REPORTS, CLEANUPS }
