import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/report.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/screens/camera.dart';
import 'package:emrals/screens/map.dart';
import 'package:emrals/screens/profile.dart';
import 'package:emrals/screens/report_detail.dart';
import 'package:emrals/state_container.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:share/share.dart';
import 'package:emrals/data/rest_ds.dart';
import 'package:location/location.dart';

class ReportListWidget extends StatefulWidget {
  @override
  _ReportList createState() => _ReportList();
}

class _ReportList extends State<ReportListWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final formatter = new NumberFormat("#,###");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int limit = 50;
  int offset = 0;
  ScrollController _scrollController = ScrollController();
  List<Report> reports = List();
  List<Report> nearbyreports = List();
  bool _progressBarActive = true;
  BuildContext _ctx;
  User user;
  var currentLocation = <String, double>{};
  var location = Location();

  @override
  void initState() {
    super.initState();
    fetchReports(limit: 50, offset: 0);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        offset += limit;
        fetchReports(
          offset: offset,
          limit: limit,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() {
    return fetchReports(
      limit: 50,
      offset: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    User user = StateContainer.of(context).loggedInUser;
    this.user = user;
    _ctx = context;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          child: Container(
            color: Colors.black,
            height: 30.0,
            child: TabBar(
              labelColor: Colors.white,
              tabs: [
                Tab(
                  text: 'recent',
                ),
                Tab(
                  text: 'closest',
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(30.0),
        ),
        key: _scaffoldKey,
        body: TabBarView(
          children: [
            _progressBarActive == true
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: reports.length,
                      itemBuilder: (BuildContext context, int index) {
                        AnimationController emralsAnimationController =
                            AnimationController(
                          vsync: this,
                          duration: Duration(milliseconds: 500),
                        );
                        Animation<double> emralsAnimation = Tween<double>(
                          begin: 0,
                          end: double.parse(
                                  reports[index].solutionEmralsAmount) +
                              double.parse(reports[index].reportEmralsAmount),
                        ).animate(
                          CurvedAnimation(
                            parent: emralsAnimationController,
                            curve: Curves.linear,
                          ),
                        );
                        emralsAnimationController.forward();
                        return Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => ProfileDialog(
                                            id: reports[index].creator));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          stops: [0, 0.5, 1],
                                          colors: [
                                            const Color(0xFF7DB208),
                                            const Color(0xFFFFDC03),
                                            const Color(0xFFDD26BA),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              reports[index].posterAvatar,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        reports[index].posterUsername,
                                        style: TextStyle(
                                            color: emralsColor(),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(reports[index].solution != ''
                                          ? 'cleans ${reports[index].timeAgo} ago '
                                          : 'reports ${reports[index].timeAgo} ago '),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'earned',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: emralsColor(),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/greene.png",
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          AnimatedBuilder(
                                            animation: emralsAnimation,
                                            builder: (ctx, widget) {
                                              return Text(
                                                formatter.format(
                                                    emralsAnimation.value),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: emralsColor()),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReportDetail(
                                          report: reports[index],
                                          reports: reports)),
                                );
                              },
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    placeholder: AspectRatio(aspectRatio: 1),
                                    imageUrl: reports[index].solution != ''
                                        ? reports[index].solution
                                        : reports[index].thumbnail,
                                    errorWidget: Icon(Icons.error),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(8),
                                        child: Text(reports[index].title),
                                        decoration: BoxDecoration(
                                            color: Colors.white70),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, top: 5),
                                        child: Text(
                                          "#" + reports[index].id.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.5, 1.5),
                                                blurRadius: 1.0,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  reports[index].solution != ""
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff7c94b6),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        reports[index]
                                                            .thumbnail),
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
                                      : Container(),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Hero(
                                      tag: reports[index].id,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MapPage(
                                                    report: reports[index])),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 10, bottom: 10),
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff7c94b6),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  reports[index].googleURL),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            border: Border.all(
                                              color: emralsColor(),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Opacity(
                                  opacity:
                                      reports[index].solution != '' ? 0.0 : 1,
                                  child: RaisedButton.icon(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: reports[index].solution != ''
                                        ? null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CameraApp(
                                                    report: reports[index]),
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
                                ),
                                OutlineButton(
                                  color: Colors.white,
                                  splashColor: emralsColor(),
                                  //disabledColor: emralsColor(),
                                  highlightColor: emralsColor().shade700,
                                  disabledTextColor: emralsColor(),
                                  textColor: emralsColor(),
                                  borderSide: BorderSide(
                                    color: emralsColor(),
                                  ),
                                  onPressed: () {
                                    Share.share(
                                        "http://www.emrals.com/alerts/" +
                                            reports[index].slug);
                                  },
                                  child: Text("SHARE"),
                                  shape: StadiumBorder(),
                                ),
                                OutlineButton(
                                  color: Colors.white,
                                  splashColor: emralsColor(),
                                  //disabledColor: emralsColor(),
                                  highlightColor: emralsColor().shade700,
                                  disabledTextColor: emralsColor(),
                                  textColor: emralsColor(),
                                  borderSide: BorderSide(
                                    color: emralsColor(),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return TipDialog(
                                              reports[index], _scaffoldKey);
                                        }).then((d) {
                                      if (d != null) {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                content: Container(
                                                  child:
                                                      CircularProgressIndicator(),
                                                  alignment: Alignment.center,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              );
                                            });
                                        _handleRefresh().whenComplete(() {
                                          StateContainer.of(context)
                                              .updateEmrals(
                                                  StateContainer.of(context)
                                                          .emralsBalance -
                                                      d);
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: Text("TIP"),
                                  shape: StadiumBorder(),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey,
                            )
                          ],
                        );
                      },
                    ),
                  ),
            _progressBarActive == true
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: nearbyreports.length,
                      itemBuilder: (BuildContext context, int index) {
                        AnimationController emralsAnimationController =
                            AnimationController(
                          vsync: this,
                          duration: Duration(milliseconds: 500),
                        );
                        Animation<double> emralsAnimation = Tween<double>(
                          begin: 0,
                          end: double.parse(
                                  nearbyreports[index].solutionEmralsAmount) +
                              double.parse(
                                  nearbyreports[index].reportEmralsAmount),
                        ).animate(
                          CurvedAnimation(
                            parent: emralsAnimationController,
                            curve: Curves.linear,
                          ),
                        );
                        emralsAnimationController.forward();
                        return Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => ProfileDialog(
                                            id: nearbyreports[index].creator));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          stops: [0, 0.5, 1],
                                          colors: [
                                            const Color(0xFF7DB208),
                                            const Color(0xFFFFDC03),
                                            const Color(0xFFDD26BA),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              nearbyreports[index].posterAvatar,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        nearbyreports[index].posterUsername,
                                        style: TextStyle(
                                            color: emralsColor(),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(nearbyreports[index].solution != ''
                                          ? 'cleans ${nearbyreports[index].timeAgo} ago '
                                          : 'reports ${nearbyreports[index].timeAgo} ago '),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'earned',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: emralsColor(),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/greene.png",
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          AnimatedBuilder(
                                            animation: emralsAnimation,
                                            builder: (ctx, widget) {
                                              return Text(
                                                formatter.format(
                                                    emralsAnimation.value),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: emralsColor()),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReportDetail(
                                          report: nearbyreports[index],
                                          reports: nearbyreports)),
                                );
                              },
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    placeholder: AspectRatio(aspectRatio: 1),
                                    imageUrl:
                                        nearbyreports[index].solution != ''
                                            ? nearbyreports[index].solution
                                            : nearbyreports[index].thumbnail,
                                    errorWidget: Icon(Icons.error),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(8),
                                    child: Text(nearbyreports[index].title),
                                    decoration:
                                        BoxDecoration(color: Colors.white70),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 35, 0, 0),
                                    child: Text(
                                      "#" + nearbyreports[index].id.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(1.5, 1.5),
                                            blurRadius: 1.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  nearbyreports[index].solution != ""
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff7c94b6),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        nearbyreports[index]
                                                            .thumbnail),
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
                                      : Container(),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Hero(
                                      tag: nearbyreports[index].id,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MapPage(
                                                    report:
                                                        nearbyreports[index])),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 10, bottom: 10),
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff7c94b6),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  nearbyreports[index]
                                                      .googleURL),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            border: Border.all(
                                              color: emralsColor(),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Opacity(
                                  opacity: nearbyreports[index].solution != ''
                                      ? 0.0
                                      : 1,
                                  child: RaisedButton.icon(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: nearbyreports[index].solution !=
                                            ''
                                        ? null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CameraApp(
                                                    report:
                                                        nearbyreports[index]),
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
                                ),
                                OutlineButton(
                                  color: Colors.white,
                                  splashColor: emralsColor(),
                                  //disabledColor: emralsColor(),
                                  highlightColor: emralsColor().shade700,
                                  disabledTextColor: emralsColor(),
                                  textColor: emralsColor(),
                                  borderSide: BorderSide(
                                    color: emralsColor(),
                                  ),
                                  onPressed: () {
                                    Share.share(
                                        "http://www.emrals.com/alerts/" +
                                            nearbyreports[index].slug);
                                  },
                                  child: Text("SHARE"),
                                  shape: StadiumBorder(),
                                ),
                                OutlineButton(
                                  color: Colors.white,
                                  splashColor: emralsColor(),
                                  //disabledColor: emralsColor(),
                                  highlightColor: emralsColor().shade700,
                                  disabledTextColor: emralsColor(),
                                  textColor: emralsColor(),
                                  borderSide: BorderSide(
                                    color: emralsColor(),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return TipDialog(nearbyreports[index],
                                              _scaffoldKey);
                                        }).then((d) {
                                      if (d != null) {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                content: Container(
                                                  child:
                                                      CircularProgressIndicator(),
                                                  alignment: Alignment.center,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              );
                                            });
                                        _handleRefresh().whenComplete(() {
                                          StateContainer.of(context)
                                              .updateEmrals(
                                                  StateContainer.of(context)
                                                          .emralsBalance -
                                                      d);
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: Text("TIP"),
                                  shape: StadiumBorder(),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey,
                            )
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  fetchReports({
    int offset,
    int limit,
  }) async {
    try {
      try {
        currentLocation = await location.getLocation();
        var encodedUrl = Uri.encodeFull(
            'alerts/?limit=$limit&offset=$offset&longitude=${currentLocation["longitude"]}&latitude=${currentLocation["latitude"]}');
        print(apiUrl + encodedUrl);
        final nearbyresponse = await http.get(apiUrl + encodedUrl);

        var nearbydata = json.decode(nearbyresponse.body);
        print(nearbyresponse.body);
        var nearbyparsed = nearbydata["results"] as List;

        if (offset > 50) {
          nearbyreports.addAll(nearbyparsed
              .map<Report>((json) => Report.fromJson(json))
              .toList());
        } else {
          nearbyreports = nearbyparsed
              .map<Report>((json) => Report.fromJson(json))
              .toList();
        }
      } catch (e) {
        final snackBar =
            SnackBar(content: Text('Please enable GPS' + e.toString()));
        Scaffold.of(_ctx).showSnackBar(snackBar);
        _progressBarActive = false;
      }

      final response =
          await http.get(apiUrl + 'alerts/?limit=$limit&offset=$offset');

      var data = json.decode(response.body);
      var parsed = data["results"] as List;

      if (!mounted) return;

      this.setState(() {
        RestDatasource()
            .updateEmrals(StateContainer.of(_ctx).loggedInUser.token)
            .then((e) {
          if (user.emrals != double.parse(e['emrals_amount'])) {
            StateContainer.of(_ctx)
                .updateEmrals(double.parse(e['emrals_amount']));
            user.emrals = double.parse(e['emrals_amount']);
            DatabaseHelper().updateUser(user);
          }
        });

        DatabaseHelper().getReports().then((m) {
          m.forEach((report) {
            upload(report.filename, report.longitude, report.latitude, user);
          });
        });
        if (offset > 50) {
          reports.addAll(
              parsed.map<Report>((json) => Report.fromJson(json)).toList());
        } else {
          reports =
              parsed.map<Report>((json) => Report.fromJson(json)).toList();
        }

        _progressBarActive = false;
      });
    } catch (e) {
      final snackBar = SnackBar(content: Text('Offline Mode' + e.toString()));
      Scaffold.of(_ctx).showSnackBar(snackBar);
      _progressBarActive = false;
    }
  }

  upload(String filename, double longitude, double latitude, User user) async {
    File imageFile = File(filename);

    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(apiUrl + "upload/");

    var request = http.MultipartRequest("POST", uri);
    request.fields['longitude'] = longitude.toString();
    request.fields['latitude'] = latitude.toString();

    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(imageFile.path),
    );
    Map<String, String> headers = {"Authorization": "token " + user.token};

    request.headers.addAll(headers);
    request.files.add(multipartFile);

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      if (value.contains('success')) {
        DatabaseHelper().deletereport(filename);
      }

      final snackBar = SnackBar(content: Text(value));
      Scaffold.of(_ctx).showSnackBar(snackBar);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
