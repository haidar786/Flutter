import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:emrals/models/zone.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/styles.dart';

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
  String searchTerm = "";
  bool searchActive = false;

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

  Future<void> _handleRefresh() {
    _progressBarActive = true;
    return fetchZones(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    zones.retainWhere((z) => z.city.toLowerCase().contains(searchTerm.toLowerCase()));
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            searchActive = true;
          });
        },
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      appBar: searchActive
          ? PreferredSize(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                color: Colors.black,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Search...",
                          labelStyle: TextStyle(color: Colors.white30),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                        onChanged: (s) {
                          setState(() {
                            searchTerm = s;
                            if (s.isEmpty) _handleRefresh();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          searchTerm = "";
                          searchActive = false;
                          zones = [];
                          _progressBarActive = true;
                          fetchZones(0, 10);
                        });
                      },
                    )
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(50))
          : null,
      backgroundColor: Colors.white,
      body: _progressBarActive == true
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: zones.length,
                itemBuilder: (BuildContext context, int index) {
                  Zone zone = zones[index];
                  return ZoneListItem(zone: zone);
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

class ZoneListItem extends StatelessWidget {
  final Zone zone;

  ZoneListItem({this.zone});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    placeholder: Image.asset(
                      'assets/placeholder.png',
                      fit: BoxFit.cover,
                    ),
                    imageUrl: zone.image,
                    errorWidget: Icon(Icons.error),
                  ),
                  CachedNetworkImage(
                    height: 30,
                    imageUrl: zone.flag,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    zone.city,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: emralsColor().shade50),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset("assets/JustElogo.png",
                          width: 20, height: 20),
                      SizedBox(width: 5),
                      Text(
                        "${zone.emralsAmount} emrals",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: emralsColor()[1000],
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "${zone.subscriberCount} sponsors",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Image.asset("assets/trophy.png",
                          width: 20, height: 20, color: emralsColor()[1400]),
                      SizedBox(width: 5),
                      Text(
                        "${zone.emralsAmount} emrals",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                      padding: EdgeInsets.zero,
                      shape: StadiumBorder(),
                      color: emralsColor()[1000],
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "FUND",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
