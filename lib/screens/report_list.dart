import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:emrals/screens/report_detail.dart';
import 'package:emrals/models/report.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/styles.dart';
import 'package:emrals/screens/camera.dart';

class ReportListWidget extends StatefulWidget {
  @override
  _ReportList createState() => _ReportList();
}

class DialogDemoItem extends StatelessWidget {
  const DialogDemoItem(
      {Key key, this.icon, this.color, this.text, this.onPressed})
      : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class _ReportList extends State<ReportListWidget> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int limit = 50;
  int offset = 0;
  ScrollController _scrollController = ScrollController();
  List<Report> reports = List();
  bool _progressBarActive = true;

  @override
  void initState() {
    super.initState();
    fetchReports(limit: 50, offset: 0);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //limit += 50;
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

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('You tipped: $value')));
      }
    });
  }

  Future<void> _handleRefresh() {
    reports = List<Report>();
    return fetchReports(
      limit: limit,
      offset: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _progressBarActive == true
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: reports.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReportDetail(report: reports[index])),
                          );
                        },
                        child: Stack(
                          alignment: const Alignment(.9, .9),
                          children: [
                            CachedNetworkImage(
                              placeholder:
                                  Image.asset('assets/placeholder.png'),
                              imageUrl: reports[index].solution != ''
                                  ? reports[index].solution
                                  : reports[index].thumbnail,
                              errorWidget: Icon(Icons.error),
                            ),
                            GestureDetector(
                              onTap: () {
                                reports[index].launchMaps();
                              },
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(reports[index].googleURL),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  border: Border.all(
                                    color: emralsColor(),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                width: 77,
                                height: 77,
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
                            Expanded(
                              child: Container(
                                child: RichText(
                                  //textAlign: TextAlign.right,
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: reports[index].posterUsername,
                                        style: TextStyle(
                                            color: emralsColor(),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: reports[index].solution != ''
                                            ? ' cleans #${reports[index].id} '
                                            : ' reports #${reports[index].id} ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: reports[index].title,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      reports[index].solution != ''
                                          ? Icons.local_florist
                                          : Icons.assessment,
                                      color: emralsColor(),
                                    ),
                                    Text(reports[index].solution != ''
                                        ? reports[index].solutionEmralsAmount
                                        : reports[index].reportEmralsAmount),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Opacity(
                              opacity: reports[index].solution != '' ? 0.0 : 1,
                              child: OutlineButton(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CameraApp(report: reports[index]),
                                    ),
                                  );
                                },
                                child: Text("CLEAN"),
                                shape: StadiumBorder(),
                              ),
                            ),
                            Opacity(
                              opacity: reports[index].solution != '' ? 0.0 : 1,
                              child: OutlineButton(
                                color: Colors.white,
                                splashColor: emralsColor(),
                                //disabledColor: emralsColor(),
                                highlightColor: emralsColor().shade700,
                                disabledTextColor: emralsColor(),
                                textColor: emralsColor(),
                                borderSide: BorderSide(
                                  color: emralsColor(),
                                ),
                                onPressed: () {},
                                child: Text("FUND"),
                                shape: StadiumBorder(),
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
                                showDemoDialog<String>(
                                  context: context,
                                  child: SimpleDialog(
                                    title: const Text('Select tip amount'),
                                    children: <Widget>[
                                      DialogDemoItem(
                                        icon: Icons.send,
                                        color: emralsColor(),
                                        text: 'Tip ' +
                                            reports[index].posterUsername +
                                            ' 10 EMRALS',
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            '10 EMRALS to ' +
                                                reports[index].posterUsername,
                                          );
                                        },
                                      ),
                                      DialogDemoItem(
                                        icon: Icons.send,
                                        color: emralsColor(),
                                        text: 'Tip ' +
                                            reports[index].posterUsername +
                                            ' 50 EMRALS',
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            '50 EMRALS to ' +
                                                reports[index].posterUsername,
                                          );
                                        },
                                      ),
                                      DialogDemoItem(
                                        icon: Icons.send,
                                        text: 'Tip ' +
                                            reports[index].posterUsername +
                                            ' 100 EMRALS',
                                        color: emralsColor(),
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            '100 EMRALS to ' +
                                                reports[index].posterUsername,
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Text("TIP"),
                              shape: StadiumBorder(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  fetchReports({
    int offset,
    int limit,
  }) async {
    print('fetching reports: limit=${limit.toString()}, offset=${offset.toString()}');
    final response = await http
        .get('https://www.emrals.com/api/alerts/?limit=$limit&offset=$offset');

    var data = json.decode(response.body);
    var parsed = data["results"] as List;
    if (!mounted) return;
    this.setState(() {
      reports
          .addAll(parsed.map<Report>((json) => Report.fromJson(json)).toList());
      _progressBarActive = false;
    });
  }
}
