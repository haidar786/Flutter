import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/components/animated_user_emrals.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:emrals/models/report.dart';
import 'package:emrals/models/report_comment.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/map.dart';
import 'package:emrals/screens/profile.dart';
import 'package:emrals/state_container.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class ReportDetail extends StatefulWidget {
  final Report report;
  final List reports;

  ReportDetail({Key key, @required this.report, this.reports})
      : super(key: key);

  @override
  ReportDetailState createState() {
    return ReportDetailState();
  }
}

class ReportDetailState extends State<ReportDetail> {
  final formatter = new NumberFormat("#,###");
  final TextEditingController commentEditingController =
      TextEditingController();
  List<ReportComment> reportComments;
  ScrollController _controller;
  User loggedInUser;
  PageController pageController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    pageController =
        PageController(initialPage: widget.reports.indexOf(widget.report));
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = StateContainer.of(context).loggedInUser;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Report Detail"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: AnimatedUserEmrals(
                initialEmrals: StateContainer.of(context).emralsBalance,
              )),
          IconButton(
            icon: Image.asset("assets/JustElogo.png"),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: widget.reports.length,
        itemBuilder: (ctx, index) {
          Report report = widget.reports[index];
          return ListView(
            controller: _controller,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: report.solution != ""
                        ? report.solution
                        : report.thumbnail,
                    placeholder: AspectRatio(aspectRatio: 1),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    child: Text(report.title),
                    decoration: BoxDecoration(color: Colors.white70),
                  ),
                  report.solution != ""
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
                                    image: NetworkImage(report.thumbnail),
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
                      : (loggedInUser != null &&
                              report.posterUsername == loggedInUser.username)
                          ? Positioned(
                              bottom: 2,
                              left: 10,
                              child: RaisedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          title: Text(
                                              "Are you sure you want to delete this report?"),
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
                                      RestDatasource()
                                          .deleteReport(
                                              report.id, loggedInUser.token)
                                          .then((m) {
                                        widget.reports.removeWhere(
                                            (item) => item.id == report.id);
                                        Navigator.of(context).pop();
                                      });
                                    }
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapPage(report: report)),
                        );
//                        report.launchMaps();
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
                        .format(double.parse(report.reportEmralsAmount)))
                  ]),
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
                  IntrinsicWidth(
                    child: Column(
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
                                  return TipDialog(report, scaffoldKey);
                                }).then((d) {
                              if (d != null) {
                                StateContainer.of(context).updateEmrals(
                                    StateContainer.of(context).emralsBalance -
                                        d);
                                setState(() {
                                  if (report.solution.isEmpty) {
                                    widget.report.reportEmralsAmount =
                                        (double.parse(
                                                    report.reportEmralsAmount) +
                                                d)
                                            .toString();
                                  } else {
                                    report.solutionEmralsAmount = (double.parse(
                                                widget.report
                                                    .solutionEmralsAmount) +
                                            d)
                                        .toString();
                                  }
                                });
                              }
                            });
                          },
                          label: Text(
                            "Tip Emrals",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                            side: BorderSide(
                                color: Theme.of(context).accentColor, width: 2),
                          ),
                          color: Colors.white,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton.icon(
                                icon: Icon(
                                  Icons.share,
                                  color: emralsColor(),
                                ),
                                onPressed: () {
                                  Share.share(
                                      "http://www.emrals.com/alerts/${report.slug}");
                                },
                                label: Text(
                                  "Share",
                                  style: TextStyle(color: emralsColor()),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 2),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  report.solution != ''
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
                              "${report.solutionEmralsAmount} EMRALS WON!",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: emralsColor()),
                            ),
                            Text(
                              "Congrats ${report.posterUsername}",
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
                          onTap: () {
                            _controller.jumpTo(500);
                          },
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
                              RestDatasource()
                                  .addCommentToReport(
                                      widget.report.id,
                                      commentEditingController.text,
                                      loggedInUser)
                                  .then((b) {
                                commentEditingController.text = "";
                                setState(() {
                                  reportComments.insert(0, b);
                                });

                                scaffoldKey.currentState.showSnackBar(
                                    SnackBar(content: Text("Comment Posted!")));
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future: RestDatasource().getReportComments(report.id),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    reportComments = snapshot.data;
                    if (reportComments.length > 0) {
                      return ListView.separated(
                        padding: EdgeInsets.all(16),
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          ReportComment comment = reportComments[index];
                          return ReportCommentListItem(comment: comment);
                        },
                        itemCount: reportComments.length,
                        shrinkWrap: true,
                        separatorBuilder: (ctx, index) => Divider(),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: Center(
                          child: Text(
                            "No comments :(",
                            style: TextStyle(color: Colors.black45),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}

class ReportCommentListItem extends StatelessWidget {
  final ReportComment comment;

  ReportCommentListItem({this.comment});

  @override
  Widget build(BuildContext context) {
    User loggedInUser = StateContainer.of(context).loggedInUser;
    bool loggedInUserComment = loggedInUser.id == comment.userid;
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) => ProfileDialog(
                  id: comment.userid,
                ));
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
                                      "Are you sure you want to ${loggedInUserComment ? "delete" : "flag"} this comment?"),
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
                              if (!loggedInUserComment) {
                                RestDatasource()
                                    .flagComment(comment.id, loggedInUser.token)
                                    .then((m) {
                                  final snackBar = SnackBar(content: Text(m));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                });
                              } else {
                                RestDatasource()
                                    .deleteComment(
                                        comment.id, loggedInUser.token)
                                    .then((m) {
                                  final snackBar = SnackBar(content: Text(m));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                });
                              }
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            !loggedInUserComment ? "Flag" : "Delete",
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
        User loggedInUser = StateContainer.of(context).loggedInUser;
        if (loggedInUser.emrals > number) {
          if (report.solution != '') {
            RestDatasource()
                .tipCleanup(number, report.id, loggedInUser.token)
                .then((m) {
              Navigator.of(context).pop(number);
              loggedInUser.emrals = loggedInUser.emrals - number;
              DatabaseHelper().updateUser(loggedInUser);
              scaffoldKey.currentState
                  .showSnackBar(SnackBar(content: Text(m['message'])));
            });
          } else {
            RestDatasource()
                .tipReport(number, report.id, loggedInUser.token)
                .then((m) {
              Navigator.of(context).pop(number);
              loggedInUser.emrals = loggedInUser.emrals - number;
              DatabaseHelper().updateUser(loggedInUser);
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
