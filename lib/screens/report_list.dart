import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:emrals/screens/report_detail.dart';
import 'package:emrals/models/report.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportListWidget extends StatefulWidget {
  @override
  _ReportList createState() => _ReportList();
}

class _ReportList extends State<ReportListWidget> {
  int limit = 50;
  int offset = 0;
  ScrollController _scrollController = ScrollController();
  List<Report> reports = List();
  bool _progressBarActive = true;
  @override
  void initState() {
    super.initState();
    fetchReports(0, 0);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //limit += 50;
        offset += 50;
        fetchReports(limit, offset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  launchMaps(latitude, longitude) async {
    String googleUrl = 'geo:0,0?q=$latitude,$longitude';
    String googleiOSUrl = 'googlemaps://?q=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
    if (await canLaunch("geo://")) {
      print('launching com googleUrl' + googleUrl);
      await launch(googleUrl);
    } else if (await canLaunch(googleiOSUrl)) {
      print('launching apple url' + googleiOSUrl);
      await launch(googleiOSUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url' + appleUrl);
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _progressBarActive == true
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                            placeholder: Image.asset('assets/placeholder.png'),
                            imageUrl: reports[index].thumbnail,
                            errorWidget: Icon(Icons.error),
                          ),
                          GestureDetector(
                            onTap: () {
                              launchMaps(
                                reports[index].latitude,
                                reports[index].longitude,
                              );

                              print("Container clicked");
                            },
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff7c94b6),
                                image: DecorationImage(
                                  image: NetworkImage(reports[index].googleURL),
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
                                      text: ' reports ',
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
                                    Icons.assessment,
                                    color: emralsColor(),
                                  ),
                                  Text('200'),
                                ],
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
                                onPressed: () {},
                                child: Text("CLEAN"),
                                shape: StadiumBorder(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  fetchReports(
    int offset,
    int limit,
  ) async {
    print('fetching reportsss' + limit.toString() + offset.toString());
    final response = await http
        .get('https://www.emrals.com/api/alerts/?limit=$limit&offset=$offset');

    var data = json.decode(response.body);
    var parsed = data["results"] as List;
    setState(() {
      reports
          .addAll(parsed.map<Report>((json) => Report.fromJson(json)).toList());
      _progressBarActive = false;
    });
  }
}
