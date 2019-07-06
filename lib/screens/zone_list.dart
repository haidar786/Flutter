import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emrals/models/zone.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class ZoneListWidget extends StatefulWidget {
  @override
  _ZoneList createState() => _ZoneList();
}

class _ZoneList extends State<ZoneListWidget>
    with AutomaticKeepAliveClientMixin {
  int limit = 50;
  int offset = 0;
  ScrollController _scrollController = ScrollController();
  List<Zone> zones = List();
  bool _progressBarActive = true;
  String searchTerm = "";
  bool searchActive = false;
  ZoneSortType sortType = ZoneSortType.RECENT;
  var currentLocation = <String, double>{};
  var location = Location();

  @override
  void initState() {
    super.initState();
    fetchZones(0, 0, sortType);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        limit = 50;
        offset += 50;
        fetchZones(limit, offset, sortType);
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
    zones = List<Zone>();
    return fetchZones(0, 0, sortType);
  }

  @override
  Widget build(BuildContext context) {
    zones.retainWhere(
        (z) => z.city.toLowerCase().contains(searchTerm.toLowerCase()));
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onPressed: (() {
              showDialog(
                  context: context,
                  builder: (ctx) => ZoneSortDialog(
                        initialSort: sortType,
                      )).then((d) {
                setState(() {
                  sortType = d;
                  _handleRefresh();
                });
              });
            }),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
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
        ],
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
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
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
                          fetchZones(0, 10, sortType);
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
    sortType,
  ) async {
    var requestURL = apiUrl +
        'zones/?limit=$limit&offset=$offset&sort=' +
        sortType.toString();
    if (sortType == ZoneSortType.CLOSEST) {
      currentLocation = await location.getLocation();
      requestURL = apiUrl +
          'zones/?limit=$limit&offset=$offset&longitude=${currentLocation["longitude"]}&latitude=${currentLocation["latitude"]}';
    }
    print(requestURL);
    final response = await http.get(requestURL);

    var data = json.decode(response.body);
    var parsed = data["results"] as List;
    if (!mounted) return;
    setState(() {
      zones.addAll(parsed.map<Zone>((json) => Zone.fromJson(json)).toList());
      _progressBarActive = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class ZoneListItem extends StatefulWidget {
  final Zone zone;

  ZoneListItem({this.zone});

  @override
  _ZoneListItemState createState() => _ZoneListItemState();
}

class _ZoneListItemState extends State<ZoneListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      widget.zone.image != null
                          ? CachedNetworkImage(
                              placeholder: Image.asset(
                                'assets/placeholder.png',
                                fit: BoxFit.cover,
                              ),
                              imageUrl: widget.zone.image,
                              errorWidget: Icon(Icons.error),
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: Text('No Image'),
                            ),
                      CachedNetworkImage(
                        height: 30,
                        imageUrl: widget.zone.flag,
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
                        widget.zone.city,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: emralsColor().shade50),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset("assets/greene.png",
                              width: 18, height: 18),
                          SizedBox(width: 5),
                          Text(
                            "${widget.zone.emralsAmount} emrals",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: emralsColor()[1000],
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${widget.zone.subscriberCount} sponsors",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: emralsColor()[1500],
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${widget.zone.reportCount} reports",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Image.asset("assets/trophy.png",
                              width: 15,
                              height: 15,
                              color: emralsColor()[1400]),
                          SizedBox(width: 5),
                          Text(
                            "${widget.zone.cleanupCount} cleanups",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      RaisedButton(
                          padding: EdgeInsets.zero,
                          shape: StadiumBorder(),
                          color: emralsColor()[1000],
                          onPressed: () {
                            _showModal(widget.zone);
                          },
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
        ),
        Container(
          height: 10,
          color: Colors.black,
        )
      ],
    );
  }

  void _showModal(zone) {
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.directions_walk),
              title: new Text('100 EMRALS / month ' + zone.city),
              onTap: () {},
            ),
            new ListTile(
              leading: new Icon(Icons.directions_run),
              title: new Text('200 EMRALS / month ' + zone.city),
              onTap: () {},
            ),
            new ListTile(
              leading: new Icon(Icons.directions_bike),
              title: new Text('500 EMRALS / month ' + zone.city),
              onTap: () {},
            ),
          ],
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    print('modal closed');
  }
}

class ZoneSortDialog extends StatefulWidget {
  final ZoneSortType initialSort;

  ZoneSortDialog({this.initialSort});

  @override
  _ZoneSortDialogState createState() => _ZoneSortDialogState();
}

class _ZoneSortDialogState extends State<ZoneSortDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Sort Zones"),
      content: SingleChildScrollView(
        child: Column(
          children: ZoneSortType.values.map((z) {
            return ListTile(
              onTap: () {
                Navigator.pop(context, z);
              },
              title: Text(z.toString().split(".")[1]),
              trailing: widget.initialSort == z
                  ? Icon(
                      Icons.check,
                      color: emralsColor(),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

enum ZoneSortType {
  RECENT,
  EMRALS,
  CLEANUPS,
  REPORTS,
  CLOSEST,
  VIEWS,
  SUBSCRIBERS,
}
