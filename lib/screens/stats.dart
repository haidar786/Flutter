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
      throw Exception('Failed to update stats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
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
          ),
        ],
      ),
    );
  }
}
