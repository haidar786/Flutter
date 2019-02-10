import 'package:emrals/data/database_helper.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:flutter/material.dart';
import 'package:emrals/models/report.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:emrals/styles.dart';

class ReportDetail extends StatelessWidget {
  final Report report;

  ReportDetail({Key key, @required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(report);
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Detail"),
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: report.thumbnail,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8),
                child: Text(report.title),
                decoration: BoxDecoration(color: Colors.white70),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    report.launchMaps();
                    print("Container clicked");
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: NetworkImage(report.googleURL),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(children: <Widget>[
                Image.asset(
                  "assets/JustElogo.png",
                  width: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(report.reportEmralsAmount)
              ]),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.visibility,
                    color: Colors.purpleAccent,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(report.views.toString()),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.cyan.shade600,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(report.posterUsername),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    color: Colors.yellow.shade700,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(report.timeAgo),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton.icon(
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return TipDialog(report.id);
                      });
                },
                label: Text(
                  "Tip Emrals",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(
                      color: Theme.of(context).accentColor, width: 2),
                ),
                color: Colors.white,
              ),
              RaisedButton.icon(
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: () {},
                label: Text(
                  "Clean",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                color: Theme.of(context).accentColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TipDialog extends StatelessWidget {
  final int reportID;
  TipDialog(this.reportID);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white54,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Tip Emrals".toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                EmralsTipCircleButton(10, Colors.purple, reportID),
                EmralsTipCircleButton(50, Theme.of(context).accentColor, reportID),
                EmralsTipCircleButton(100, Colors.cyan.shade600, reportID),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EmralsTipCircleButton extends StatelessWidget {
  final int number;
  final Color color;
  final int reportID;

  EmralsTipCircleButton(this.number, this.color, this.reportID);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DatabaseHelper().getUser().then((u) {
          if (u.emrals < number) {
                RestDatasource().tipReport(number, reportID, u.token);
          }
        });
      },
      child: Container(
        width: 77,
        height: 77,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/JustElogo.png", width: 22,),
            Text("$number", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white54,
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle),
      ),
    );
  }
}

