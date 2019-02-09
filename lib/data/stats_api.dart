//
import 'package:emrals/models/stats_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class StatsApi {
  final Client _client = Client();
  static const _statsUrl = 'https://www.emrals.com/api/stats/?format=json';
  

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
}
