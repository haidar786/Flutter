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

  Future<Crex24Model> getCrex24Data() async {
    print('fetching Crex24 data');
    Crex24Model data;
    await _client
        .get(Uri.parse(_crex24Url))
        .then((result) => result.body)
        .then(json.decode)
        .then((json) {
      data = Crex24Model.fromJson(json[0]);
    });

    return data;
  }
}
