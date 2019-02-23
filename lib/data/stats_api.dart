//
import 'dart:async';

import 'package:emrals/models/stats_exchange_model.dart';
import 'package:emrals/models/stats_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class StatsApi {
  final Client _client = Client();
  static const _statsUrl = 'https://www.emrals.com/api/stats/?format=json';
  static const _crex24Url =
      'https://api.crex24.com/v2/public/tickers?instrument=EMRALS-BTC';
  static const _crex24BtcUrl =
      'https://api.crex24.com/v2/public/tickers?instrument=BTC-USD';
  static const _connectionCountUrl =
      'http://explorer.emrals.com/api/getconnectioncount';
  static const _networkHashRateUrl =
      'http://explorer.emrals.com/api/getnetworkhashps';
  static const _moneySupplyUrl =
      'http://explorer.emrals.com/ext/getmoneysupply';
  static const _difficultyUrl = 'http://explorer.emrals.com/api/getdifficulty';

  String lastBlockTime;
  int blockHeight;

  Future<StatsModel> getStats() async {
    StatsModel stats;
    await _client
        .get(Uri.parse(_statsUrl))
        .then((result) => result.body)
        .then(json.decode)
        .then((json) {
      stats = StatsModel.fromJson(json[0]);
    });

    return stats;
  }

  Future<StatsExchangeModel> getCrex24Data() async {
    List<String> urls = [_crex24BtcUrl, _crex24Url];

    List<dynamic> mnWorthList = await Future.wait(
      urls.map(
        (url) =>
            _client.get(url).then((result) => result.body).then(json.decode),
      ),
    );

    double usdValue = mnWorthList[0][0]['last'];
    Map oldJson = mnWorthList[1][0];
    Map newJson = {
      'last': oldJson['last'] * usdValue,
      'percentChange': oldJson['percentChange'],
      'baseVolume': (oldJson['baseVolume']),
      'high': oldJson['high'] * usdValue,
      'low': oldJson['low'] * usdValue,
      'bid': oldJson['bid'] * usdValue,
      'ask': oldJson['ask'] * usdValue
    };

    return StatsExchangeModel.fromJson(newJson);
  }

  Future<int> getConnectionCount() async {
    int connectionCount;
    final response = await _client.get(_connectionCountUrl);

    if (response.statusCode == 200) {
      connectionCount = int.parse(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
    return connectionCount;
  }

  Future<double> getNetworkHashRate() async {
    double hashRate;
    final response = await _client.get(_networkHashRateUrl);
    if (response.statusCode == 200) {
      hashRate = double.parse(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
    return hashRate;
  }

  Future<double> getMoneySupply() async {
    double moneySupply;
    final response = await _client.get(_moneySupplyUrl);
    if (response.statusCode == 200) {
      moneySupply = double.parse(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
    return moneySupply;
  }

  Future<double> getDifficulty() async {
    double difficulty;
    final response = await _client.get(_difficultyUrl);
    if (response.statusCode == 200) {
      difficulty = double.parse(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
    return difficulty;
  }

  Future<double> getMNWorth() async {
    double mnWorth;
    List<String> urls = [_crex24Url, _crex24BtcUrl];

    List<double> mnWorthList = await Future.wait(urls.map(
      (url) => _client
          .get(url)
          .then((result) => result.body)
          .then(json.decode)
          .then((json) => json[0]['last'] as double),
    ));

    mnWorth = mnWorthList[0] * mnWorthList[1] * 1000;

    return mnWorth;
  }

  Future<String> getLastBlockTime() async {
    String lastBlockTime;
    final response =
        await _client.get('http://explorer.emrals.com/ext/getlasttxs/1/1');

    if (response.statusCode == 200) {
      var date = new DateTime.fromMillisecondsSinceEpoch(
          json.decode(response.body)['data'][0]['timestamp'] * 1000);
      var now = new DateTime.now();
      Duration difference = now.difference(date);
      lastBlockTime = difference.inMinutes.toString() + "m ";
    } else {
      throw Exception('Failed to fetch data');
    }

    return lastBlockTime;
  }

  Future<String> getBlockHeight() async {
    String blockHeight;

    final response =
        await _client.get('http://explorer.emrals.com/ext/getlasttxs/1/1');

    if (response.statusCode == 200) {
      blockHeight =
          json.decode(response.body)['data'][0]['blockindex'].toString();
    } else {
      throw Exception('Failed to fetch data');
    }

    return blockHeight;
  }
}
