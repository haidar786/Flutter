import 'dart:async';
import 'dart:math';

import 'package:emrals/data/stats_api.dart';
import 'package:emrals/models/stats_exchange_model.dart';
import 'package:emrals/models/stats_model.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class StatsScreen extends StatefulWidget {
  @override
  StatsScreenState createState() {
    return StatsScreenState();
  }
}

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class StatsScreenState extends State<StatsScreen>
    with AutomaticKeepAliveClientMixin {
  StatsApi _statsApi = StatsApi();
  StatsModel stats;
  StatsExchangeModel crex24data;
  int connectionCount;
  double networkHashRate;
  double moneySupply;
  double difficulty;
  int blockHeight;
  String lastBlockTime;
  double mnWorth;
  NumberFormat formatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Theme(
      data: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Theme.of(context).primaryColor),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
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
                child: ListView(
                  children: <Widget>[
                    CountDownText(
                      onUpdate: () {
                        _statsApi = StatsApi();
                        if (!mounted) return;
                        setState(() {});
                      },
                    ),
                    _statsRow1(context),
                    _statsRow2(context),
                    _statsRow3(context),
                    _statsRowMedia(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsRow1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: FutureBuilder(
        future: _statsApi.getStats(),
        builder: (context, snapshot) {
          StatsModel data = snapshot.data;
          return AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            crossFadeState: snapshot.connectionState == ConnectionState.done
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 160,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 160,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            secondChild: !snapshot.hasData || snapshot.hasError
                ? Row(
                    children: <Widget>[
                      // Box containing city count, country count, cleanups,
                      // reports, users, emralds won and emralds added
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 160,
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            FontAwesomeIcons.exclamationTriangle,
                            color: emralsColor()[1300],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 160,
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            FontAwesomeIcons.exclamationTriangle,
                            color: emralsColor()[1300],
                          ),
                        ),
                      )
                    ],
                  )
                : Row(
                    children: <Widget>[
                      // Box containing city count, country count, cleanups,
                      // reports, users, emralds won and emralds added
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 160,
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(
                                        color: emralsColor(),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${formatter.format(data.cities)} Cities',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(
                                        color: emralsColor(),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${formatter.format(data.countries)} Countries',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Cleanups',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${formatter.format(data.cleanups)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: emralsColor(),
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Reports',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${formatter.format(data.reports)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: emralsColor(),
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Users',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${formatter.format(data.users)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: emralsColor(),
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Emrals Earned',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${formatter.format(data.emralsWon)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: emralsColor(),
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Emrals Added',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${formatter.format(data.emralsAdded)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: emralsColor(),
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Subscriptions',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${formatter.format(data.subscribers)}',
                                            style: TextStyle(
                                              fontSize: 14,
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
                          height: 160,
                          color: Theme.of(context).primaryColor,
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
                                    '${formatter.format(data.eCans)} eCans',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          '${formatter.format(data.tosses)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: emralsColor(),
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          'Tosses',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          '${formatter.format(data.scans)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: emralsColor(),
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          'Scans',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          '${formatter.format(data.barcodes)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: emralsColor(),
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          'Barcodes',
                                          style: TextStyle(
                                            fontSize: 14,
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
        },
      ),
    );
  }

  Widget _statsRow2(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: FutureBuilder(
          future: _statsApi.getCrex24Data(),
          builder: (context, AsyncSnapshot<StatsExchangeModel> snapshot) {
            StatsExchangeModel data = snapshot.data;
            return AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              crossFadeState: snapshot.connectionState == ConnectionState.done
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 150,
                      color: Theme.of(context).primaryColor,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 150,
                      color: Theme.of(context).primaryColor,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
              secondChild: !snapshot.hasData || snapshot.hasError
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 150,
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              FontAwesomeIcons.exclamationTriangle,
                              color: emralsColor()[1300],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 150,
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              FontAwesomeIcons.exclamationTriangle,
                              color: emralsColor()[1300],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        // Box containing exchanges and the current price information
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 150,
                            color: Theme.of(context).primaryColor,
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
                                      'Links',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        'https://crex24.com/exchange/EMRALS-BTC?refid=zx68hvlsd2yucxvl7gkw');
                                  },
                                  child: Text(
                                    'Crex24',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    launchURL(
                                        'https://poolexplorer.com/coin/4742');
                                  },
                                  child: Text(
                                    'Pools',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    launchURL('http://explorer.emrals.com');
                                  },
                                  child: Text(
                                    'Explorer',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 150,
                            color: Theme.of(context).primaryColor,
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
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              '\$${data.last.toStringAsFixed(5)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              '${data.percentChange.toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                color: data.percentChange > 0
                                                    ? emralsColor()
                                                    : Colors.red,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              //'Vol. ${crex24data != null ? formatter.format(crex24data.volume) : 0}',
                                              'Vol. ${formatter.format(data.volume)}',
                                              style: TextStyle(
                                                color: emralsColor()[1400],
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'EMRALS'.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            _row2NameValueWidget(context,
                                                name: 'High',
                                                value: data.high
                                                    .toStringAsFixed(5)),
                                            _row2NameValueWidget(context,
                                                name: 'Low',
                                                value: data.low
                                                    .toStringAsFixed(5)),
                                            _row2NameValueWidget(context,
                                                name: 'Bid',
                                                value: data.bid
                                                    .toStringAsFixed(5)),
                                            _row2NameValueWidget(context,
                                                name: 'Ask',
                                                value: data.ask
                                                    .toStringAsFixed(5)),
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
          },
        ));
  }

  Widget _row2NameValueWidget(BuildContext context,
      {@required String name, @required String value}) {
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _statsRow3(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Height',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      FutureBuilder(
                        future: _statsApi.getBlockHeight(),
                        builder: (context, snapshot) {
                          String value;
                          if (snapshot.hasData &&
                              snapshot.connectionState !=
                                  ConnectionState.waiting &&
                              snapshot.data != '') {
                            value =
                                formatter.format(double.parse(snapshot.data));
                          }
                          return Text(
                            '${value ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: emralsColor()[200],
                            ),
                            textAlign: TextAlign.end,
                          );
                        },
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
                          fontSize: 14,
                        ),
                      ),
                      FutureBuilder(
                        future: _statsApi.getNetworkHashRate(),
                        builder: (context, snapshot) {
                          String value;
                          if (snapshot.hasData &&
                              snapshot.connectionState !=
                                  ConnectionState.waiting) {
                            value = formatter.format(double.parse(
                                    (snapshot.data / (pow(10, 9)))
                                        .toStringAsFixed(1))) +
                                'Gh/s';
                          }
                          return Text(
                            '${value ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: emralsColor()[200],
                            ),
                            textAlign: TextAlign.end,
                          );
                        },
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
                          fontSize: 14,
                        ),
                      ),
                      FutureBuilder(
                        future: _statsApi.getDifficulty(),
                        builder: (context, snapshot) {
                          return Text(
                            '${snapshot.hasData && snapshot.connectionState != ConnectionState.waiting ? formatter.format(double.parse(snapshot.data.toStringAsFixed(2))) : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: emralsColor()[200],
                            ),
                            textAlign: TextAlign.end,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Masternodes',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '245',
                        style: TextStyle(
                          fontSize: 14,
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
                          fontSize: 14,
                        ),
                      ),
                      FutureBuilder(
                        future: _statsApi.getMNWorth(),
                        builder: (context, snapshot) {
                          return Text(
                            '${snapshot.hasData && snapshot.connectionState != ConnectionState.waiting ? '\$' + formatter.format(snapshot.data) : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: emralsColor()[200],
                            ),
                            textAlign: TextAlign.end,
                          );
                        },
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
                          fontSize: 14,
                        ),
                      ),
                      FutureBuilder(
                        future: _statsApi.getMoneySupply(),
                        builder: (context, snapshot) {
                          return Text(
                            '${snapshot.hasData && snapshot.connectionState != ConnectionState.waiting ? formatter.format(double.parse(snapshot.data.toStringAsFixed(0))) : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: emralsColor()[200],
                            ),
                            textAlign: TextAlign.end,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Connections',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      FutureBuilder(
                        future: _statsApi.getConnectionCount(),
                        builder: (context, snapshot) {
                          return Text(
                            '${snapshot.hasData && snapshot.connectionState != ConnectionState.waiting ? formatter.format(snapshot.data) : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: emralsColor()[200],
                            ),
                            textAlign: TextAlign.end,
                          );
                        },
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
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '1,511',
                        style: TextStyle(
                          fontSize: 14,
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
                          fontSize: 14,
                        ),
                      ),
                      FutureBuilder(
                        future: _statsApi.getLastBlockTime(),
                        builder: (context, snapshot) {
                          return Text(
                            '${snapshot.hasData && snapshot.connectionState != ConnectionState.waiting ? snapshot.data : ''}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: emralsColor()[200],
                            ),
                            textAlign: TextAlign.end,
                          );
                        },
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
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(8),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 10,
        children: <Widget>[
          _mediaWidget(
            context,
            title: '',
            count: '2,598',
            icon: FontAwesomeIcons.twitterSquare,
            url: 'https://twitter.com/emralsglobal',
          ),
          _mediaWidget(
            context,
            title: '',
            count: '122',
            icon: FontAwesomeIcons.facebook,
            url: 'https://facebook.com/emrals',
          ),
          _mediaWidget(
            context,
            title: '',
            count: '440',
            icon: FontAwesomeIcons.discord,
            url: 'https://discord.gg/nUCJrkE',
          ),
          _mediaWidget(
            context,
            title: '',
            count: '51',
            icon: FontAwesomeIcons.instagram,
            url: 'https://instagram.com/emralsglobal',
          ),
        ],
      ),
    );
  }

  Widget _mediaWidget(BuildContext context,
      {@required String title,
      @required String count,
      @required String url,
      @required IconData icon}) {
    return GestureDetector(
      onTap: () {
        launchURL(url);
      },
      child: Container(
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
                color: emralsColor()[1200],
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CountDownText extends StatefulWidget {
  final VoidCallback onUpdate;

  const CountDownText({Key key, this.onUpdate}) : super(key: key);
  _CountDownTextState createState() => _CountDownTextState();
}

class _CountDownTextState extends State<CountDownText> {
  StreamSubscription periodicSub;
  static const int updateInterval = 100; // in seconds
  int countdown = updateInterval;

  @override
  void dispose() {
    periodicSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    periodicSub = periodicSub ??
        Stream.periodic(const Duration(seconds: 1), (v) => v).listen(
          (count) {
            if (count % updateInterval == 0 && count != 0) {
              widget.onUpdate();
              countdown = updateInterval;
            } else {
              countdown = updateInterval - (count % updateInterval);
            }
            if (!mounted) return;
            setState(() {});
          },
        );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Text(
        'Updating in ${countdown}s',
        textAlign: TextAlign.end,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
