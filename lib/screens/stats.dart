import 'package:emrals/data/stats_api.dart';
import 'package:emrals/models/stats_model.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Stats extends StatefulWidget {
  @override
  StatsState createState() {
    return StatsState();
  }
}

class StatsState extends State<Stats> {
  String lastBlockTime = '';
  int blockHeight;
  StatsModel stats;
  final StatsApi _statsApi = StatsApi();

  @override
  void initState() {
    updateStats();
    super.initState();
  }

  Future updateStats() async {
    final response =
        await http.get('http://explorer.emrals.com/ext/getlasttxs/1/1');

    if (response.statusCode == 200) {
      var date = new DateTime.fromMillisecondsSinceEpoch(
          json.decode(response.body)['data'][0]['timestamp'] * 1000);
      var now = new DateTime.now();
      Duration difference = now.difference(date);
      setState(() {
        this.lastBlockTime = difference.inMinutes.toString() + "m ";
        this.blockHeight = json.decode(response.body)['data'][0]['blockindex'];
      });
    } else {
      throw Exception('Failed to update');
    }
  }

  @override
  Widget build(BuildContext context) {
    _statsApi.getStats().then((stats) {
      this.stats = stats;
    });
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
      ),
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: emralsColor()[400],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.multiline_chart),
                      SizedBox(width: 4),
                      Text(
                        'Stats',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Auto refresh in XXXs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    emralsColor(),
                    emralsColor()[1400],
                    emralsColor()[800],
                    emralsColor()[50],
                    emralsColor()[1000],
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: EdgeInsets.only(top: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _statsRow1(context),
                  _statsRow2(context),
                  _statsRow3(context),
                  _statsRowMedia(context),
                ],
              ),
            ),
            /* Row(
              children: <Widget>[
                Text("Last Block: "),
                Text(lastBlockTime),
              ],
            ),
            Row(
              children: <Widget>[
                Text("Block Height: "),
                Text(blockHeight.toString()),
              ],
            ), */
          ],
        ),
      ),
    );
  }

  Widget _statsRow1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: <Widget>[
          // Box containing city count, country count, cleanups,
          // reports, users, emralds won and emralds added
          Expanded(
            flex: 2,
            child: Container(
              height: 220,
              color: Colors.black,
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: emralsColor(),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              '${stats != null ? stats.cities : 0} Cities',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: emralsColor(),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              '${stats != null ? stats.countries : 0} Countries',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Cleanups',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${stats != null ? stats.cleanups : 0}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: emralsColor(),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Reports',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${stats != null ? stats.reports : 0 }',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: emralsColor(),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Users',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${stats != null ? stats.users : 0 }',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: emralsColor(),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Emrals Won',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${stats != null ? stats.emrals_won: 0 }',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: emralsColor(),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Emrals Added',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${stats != null ? stats.emrals_added : 0 }',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: emralsColor(),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Container(
              height: 220,
              color: Colors.black,
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: emralsColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '${stats != null ? stats.e_cans : 0 } eCans',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              '${stats != null ? stats.tosses : 0 }',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: emralsColor(),
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              'Tosses',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '${stats != null ? stats.scans: 0 }',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: emralsColor(),
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              'Scans',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '${stats != null ? stats.barcodes : 0 }',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: emralsColor(),
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              'Barcodes',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _statsRow2(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: <Widget>[
          // Box containing exchanges and the current price information
          Expanded(
            flex: 1,
            child: Container(
              height: 150,
              color: Colors.black,
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: emralsColor()[1400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'Exchanges',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Crex24',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Container(
              height: 150,
              color: Colors.black,
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: emralsColor()[1400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'Price',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '\$X.XXX',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                '-X.XX%',
                                style: TextStyle(
                                  color: emralsColor(),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Vol. X,XXX',
                                style: TextStyle(
                                  color: emralsColor()[1400],
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'EMRALS'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _row2NameValueWidget(context,
                                  name: 'High', value: 0.001),
                              _row2NameValueWidget(context,
                                  name: 'Low', value: 0.001),
                              _row2NameValueWidget(context,
                                  name: 'Bid', value: 0.001),
                              _row2NameValueWidget(context,
                                  name: 'Ask', value: 0.001),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row2NameValueWidget(BuildContext context,
      {@required String name, @required double value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '\$$value',
          style: TextStyle(
            color: emralsColor()[1400],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _statsRow3(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.black,
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Height',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Hashrate',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Difficulty',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Masternodes',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'MN Worth',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Supply',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Connections',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Hosts',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Last BlkTime',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'XX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emralsColor()[200],
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRowMedia(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.black,
      padding: EdgeInsets.all(8),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 10,
        children: <Widget>[
          _mediaWidget(context,
              title: 'follows', count: 'XXXX', icon: Icons.account_circle),
          _mediaWidget(context,
              title: 'likes', count: 'XXX', icon: Icons.account_circle),
          _mediaWidget(context,
              title: 'members', count: 'XXX', icon: Icons.account_circle),
        ],
      ),
    );
  }

  Widget _mediaWidget(BuildContext context,
      {@required String title,
      @required String count,
      @required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(25),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: emralsColor()[200],
            ),
            textAlign: TextAlign.end,
          ),
          SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(width: 4),
          Icon(icon)
        ],
      ),
    );
  }
}
