import 'package:emrals/data/database_helper.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/report_comment.dart';
import 'package:emrals/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:emrals/models/report.dart';
import 'package:emrals/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/screens/camera.dart';
import 'package:emrals/styles.dart';
import 'package:intl/intl.dart';
import 'package:emrals/state_container.dart';
//import 'package:emrals/globals.dart';

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
  final formatter = new NumberFormat("#,###");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final TextEditingController commentEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    DatabaseHelper().getUser().then((u) {
      setState(() {
        user = u;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, position) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text("Report Detail"),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  formatter
                      .format(StateContainer.of(context).emralsBalance ?? 0),
                  style: TextStyle(
                    color: emralsColor(),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/JustElogo.png",
                  width: 32,
                ),
              ),
            ],
          ),
          body: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.report.solution != ""
                        ? widget.report.solution
                        : widget.report.thumbnail,
                    placeholder: AspectRatio(aspectRatio: 1),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    child: Text(widget.report.title),
                    decoration: BoxDecoration(color: Colors.white70),
                  ),
                  widget.report.solution != ""
                      ? Positioned(
                          bottom: 10,
                          left: 10,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Before",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(widget.report.thumbnail),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : (user != null &&
                              widget.report.posterUsername == user.username)
                          ? Positioned(
                              bottom: 2,
                              left: 10,
                              child: RaisedButton(
                                onPressed: () {
                                  RestDatasource()
                                      .deleteReport(
                                          widget.report.id, user.token)
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
                            color: emralsColor(),
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
                    Text(formatter
                        .format(double.parse(widget.report.reportEmralsAmount)))
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
                            return TipDialog(widget.report, scaffoldKey);
                          }).then((d) {
                        if (d != null) {
                          StateContainer.of(context).updateEmrals(
                              StateContainer.of(context).emralsBalance - d);
                          setState(() {
                            if (widget.report.solution.isEmpty) {
                              widget.report.reportEmralsAmount = (double.parse(
                                          widget.report.reportEmralsAmount) +
                                      d)
                                  .toString();
                            } else {
                              widget
                                  .report.solutionEmralsAmount = (double.parse(
                                          widget.report.solutionEmralsAmount) +
                                      d)
                                  .toString();
                            }
                          });
                        }
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
                  widget.report.solution != ''
                      ? Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset("assets/trophy.png",
                                    width: 20,
                                    height: 20,
                                    color: emralsColor()[1400]),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "CLEANED",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: emralsColor()),
                                ),
                              ],
                            ),
                            Text(
                              "${widget.report.solutionEmralsAmount} EMRALS WON!",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: emralsColor()),
                            ),
                            Text(
                              "Congrats ${widget.report.posterUsername}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: emralsColor()),
                            ),
                          ],
                        )
                      : RaisedButton.icon(
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
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Comments",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: commentEditingController,
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: "Add Comment...",
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(color: Colors.black54)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          width: 30,
                          height: 30,
                          color: emralsColor(),
                          child: IconButton(
                            icon: Icon(Icons.send),
                            color: Colors.white,
                            onPressed: () async {
                              await RestDatasource().addCommentToReport(
                                  widget.report.id,
                                  commentEditingController.text,
                                  user);
                              setState(() {});
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future: RestDatasource().getReportComments(widget.report.id),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    List<ReportComment> comments = snapshot.data;
                    return ListView.separated(
                      padding: EdgeInsets.all(16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        ReportComment comment = comments[index];
                        return ReportCommentListItem(comment: comment);
                      },
                      itemCount: comments.length,
                      shrinkWrap: true,
                      separatorBuilder: (ctx, index) => Divider(),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class ReportCommentListItem extends StatelessWidget {
  final ReportComment comment;

  ReportCommentListItem({this.comment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => Profile(
                  id: comment.userid,
                )));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            comment.userAvatar,
            width: 50,
            height: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    comment.userName,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 17),
                  ),
                  SizedBox(height: 5),
                  Text(comment.comment),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${DateTime.now().difference(comment.time).inHours} hours ago",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text(
                                      "Are you sure you want to flag this comment?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text("Yes"),
                                    ),
                                  ],
                                ),
                          ).then((d) {
                            if (d ?? false) {
                              print("flag comment");
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Flag",
                            style:
                                TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TipDialog extends StatelessWidget {
  final Report report;
  final GlobalKey<ScaffoldState> scaffoldKey;

  TipDialog(this.report, this.scaffoldKey);

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
                EmralsTipCircleButton(10, Colors.purple, report, scaffoldKey),
                EmralsTipCircleButton(
                    50, Theme.of(context).accentColor, report, scaffoldKey),
                EmralsTipCircleButton(
                    100, Colors.cyan.shade600, report, scaffoldKey),
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
  final GlobalKey<ScaffoldState> scaffoldKey;

  EmralsTipCircleButton(this.number, this.color, this.report, this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DatabaseHelper().getUser().then((u) {
          if (u.emrals > number) {
            if (report.solution != '') {
              RestDatasource().tipCleanup(number, report.id, u.token).then((m) {
                Navigator.of(context).pop(number);
                u.emrals = u.emrals - number;
                DatabaseHelper().updateUser(u);
                scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: Text(m['message'])));
              });
            } else {
              RestDatasource().tipReport(number, report.id, u.token).then((m) {
                Navigator.of(context).pop(number);
                u.emrals = u.emrals - number;
                DatabaseHelper().updateUser(u);
                scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: Text(m['message'])));
              });
            }
          } else {
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Insufficient ballance"),
              action: SnackBarAction(
                  label: "Deposit",
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed("/settings")),
            ));
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
