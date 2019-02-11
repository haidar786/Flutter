import 'package:emrals/data/database_helper.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:flutter/material.dart';
import 'package:emrals/models/report.dart';
import 'package:emrals/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/screens/camera.dart';

class ReportDetail extends StatefulWidget {
  final Report report;

  ReportDetail({Key key, @required this.report}) : super(key: key);

  @override
  ReportDetailState createState() {
    return ReportDetailState();
  }
}

class ReportDetailState extends State<ReportDetail> {
  User user;

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getUser().then((u) {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, position) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Report Detail"),
          ),
          body: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.report.thumbnail,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    child: Text(widget.report.title),
                    decoration: BoxDecoration(color: Colors.white70),
                  ),
                  widget.report.posterUsername == user.username
                      ? Positioned(
                          bottom: 2,
                          left: 10,
                          child: RaisedButton(
                            onPressed: () {
                              RestDatasource()
                                  .deleteReport(widget.report.id, user.token)
                                  .then((m) {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('delete'),
                          ),
                        )
                      : Container(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        widget.report.launchMaps();
                        print("Container clicked");
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10, bottom: 10),
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: NetworkImage(widget.report.googleURL),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
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
                    Text(widget.report.reportEmralsAmount)
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
                      Text(widget.report.views.toString()),
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
                      Text(widget.report.posterUsername),
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
                      Text(widget.report.timeAgo),
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
                            return TipDialog(widget.report);
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CameraApp(report: widget.report),
                        ),
                      );
                    },
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
      },
    );
  }
}

class TipDialog extends StatelessWidget {
  final Report report;
  TipDialog(this.report);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Tip Emrals".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                EmralsTipCircleButton(10, Colors.purple, report),
                EmralsTipCircleButton(
                    50, Theme.of(context).accentColor, report),
                EmralsTipCircleButton(100, Colors.cyan.shade600, report),
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
  final Report report;

  EmralsTipCircleButton(this.number, this.color, this.report);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DatabaseHelper().getUser().then((u) {
          if (u.emrals > number) {
            RestDatasource().tipReport(number, report.id, u.token).then((m) {
              Navigator.of(context).pop();
              report.reportEmralsAmount =
                  (double.parse(report.reportEmralsAmount) + number).toString();
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(m['message']),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    );
                  });
            });
          } else {
            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Insufficient Balance'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Deposit Emrals to Tip'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Later'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Deposit'),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed("/settings");
                        },
                      ),
                    ],
                  );
                });
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
            Image.asset(
              "assets/JustElogo.png",
              width: 22,
            ),
            Text(
              "$number",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )
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
