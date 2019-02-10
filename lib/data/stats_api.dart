//
import 'package:emrals/models/exchange_crex24_model.dart';
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
  double crex24Worth;
  Crex24Model crex24Data;

  Future<StatsModel> getStats() async {
    print('fetching stats');
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

  Future<Crex24Model> getCrex24Data({bool force = false}) async {
    if (crex24Data == null || force) {
      Crex24Model data;
      print('fetching Crex24 data');
      Crex24Model btcData;
      double usdValue;
      await _client
          .get(Uri.parse(_crex24Url))
          .then((result) => result.body)
          .then(json.decode)
          .then(
        (json) {
          data = Crex24Model.fromJson(json[0]);
          crex24Worth = json[0]['last'] * /* usdValue * */ 1000;
        },
      );

      await _client
          .get(Uri.parse(_crex24BtcUrl))
          .then((result) => result.body)
          .then(json.decode)
          .then(
        (json) {
          btcData = Crex24Model.fromJson(json[0]);
          usdValue = btcData.last;
          //crex24Worth = crex24Worth * usdValue;
        },
      );

      crex24Data = Crex24Model(
        ask: data.ask * usdValue,
        bid: data.bid * usdValue,
        high: data.high * usdValue,
        last: data.last * usdValue,
        low: data.low * usdValue,
        percentChange: data.percentChange,
        volume: data.volume,
      );
    }

    return crex24Data;
  }

  Future<int> getConnectionCount() async {
    print('fetching connection count');
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
    print('fetching network hash rate');
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
    print('fetching money supply');
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
    print('fetching difficulty supply');
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
    if (this.crex24Worth == null) {
      getCrex24Data(force: true);
    }
    return this.crex24Worth;
  }

  Future<String> getLastBlockTime() async {
    if (this.lastBlockTime == null) {
      _updateStats();
    }
    return this.lastBlockTime;
  }

  Future<int> getBlockHeight() async {
    if (this.blockHeight == null) {
      _updateStats();
    }
    return this.blockHeight;
  }

  Future _updateStats() async {
    final response =
        await _client.get('http://explorer.emrals.com/ext/getlasttxs/1/1');

    if (response.statusCode == 200) {
      var date = new DateTime.fromMillisecondsSinceEpoch(
          json.decode(response.body)['data'][0]['timestamp'] * 1000);
      var now = new DateTime.now();
      Duration difference = now.difference(date);
      this.lastBlockTime = difference.inMinutes.toString() + "m ";
      this.blockHeight = json.decode(response.body)['data'][0]['blockindex'];
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
