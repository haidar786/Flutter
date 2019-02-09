import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:emrals/models/zone.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/styles.dart';
// import 'package:url_launcher/url_launcher.dart';

class ZoneListWidget extends StatefulWidget {
  @override
  _ZoneList createState() => _ZoneList();
}

class _ZoneList extends State<ZoneListWidget> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  int limit = 50;
  int offset = 0;
  ScrollController _scrollController = ScrollController();
  List<Zone> zones = List();
  bool _progressBarActive = true;
  @override
  void initState() {
    super.initState();
    fetchZones(0, 0);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //limit += 50;
        offset += 50;
        fetchZones(limit, offset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // launchMaps(latitude, longitude) async {
  //   String googleUrl = 'geo:0,0?q=$latitude,$longitude';
  //   String comgoogleUrl = 'comgooglemaps://q?=$latitude,$longitude';
  //   String googleiOSUrl = 'googlemaps://?q=$latitude,$longitude';
  //   String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
  //   if (await canLaunch("comgooglemaps://")) {
  //     print('launching com googleUrl' + comgoogleUrl);
  //     await launch(comgoogleUrl);
  //   } else if (await canLaunch(googleUrl)) {
  //     print('launching com googleUrl' + googleUrl);
  //     await launch(googleUrl);
  //   } else if (await canLaunch(googleiOSUrl)) {
  //     print('launching googleiOSUrl url' + googleiOSUrl);
  //     await launch(googleiOSUrl);
  //   } else if (await canLaunch(appleUrl)) {
  //     print('launching appleUrl url' + appleUrl);
  //     await launch(appleUrl);
  //   } else {
  //     throw 'Could not launch url';
  //   }
  // }

  Future<void> _handleRefresh() {
    return fetchZones(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _progressBarActive == true
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: zones.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           ReportDetail(report: zones[index])),
                          // );
                        },
                        child: CachedNetworkImage(
                          placeholder: Image.asset('assets/placeholder.png'),
                          imageUrl: zones[index].image,
                          errorWidget: Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                        text: zones[index].city,
                                        style: TextStyle(
                                            color: emralsColor(),
                                            fontWeight: FontWeight.bold),
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
                                    Text(zones[index].emralsAmount),
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
                                  child: Text("FUND"),
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
            ),
    );
  }

  fetchZones(
    int offset,
    int limit,
  ) async {
    print('fetching reportsss' + limit.toString() + offset.toString());
    final response = await http
        .get('https://www.emrals.com/api/zones/?limit=$limit&offset=$offset');

    var data = json.decode(response.body);
    var parsed = data["results"] as List;
    if (!mounted) return;
    setState(() {
      zones.addAll(parsed.map<Zone>((json) => Zone.fromJson(json)).toList());
      _progressBarActive = false;
    });
  }
}
