import 'dart:convert';

import 'package:emrals/models/zone.dart';
import 'package:emrals/styles.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

class ZoneApi {
  final Client _httpClient = Client();
  final Location _location = Location();

  Future<List<Zone>> getZones({
    @required int offset,
    int limit = 50,
    @required ZoneSortType zoneSortType,
  }) async {
    List<Zone> zoneList;
    String zoneListUrl;
    if (zoneSortType == ZoneSortType.CLOSEST) {
      // Location required
      try {
        final LocationData currentLocation = await _location.getLocation();
        zoneListUrl =
            '$apiUrl/zones/?limit=$limit&offset=$offset&sort=${zoneSortType.toString()}&longitude=${currentLocation.longitude}&latitude=${currentLocation.latitude}';
      } on Exception catch (e) {
        print(e);
        throw Exception(e);
      }
    } else {
      zoneListUrl =
          '$apiUrl/zones/?limit=$limit&offset=$offset&sort=${zoneSortType.toString()}';
    }
    final Response response = await _httpClient.get(zoneListUrl);
    final Map data = json.decode(response.body);
    final List results = data['results'] as List;
    zoneList = results.map<Zone>((json) => Zone.fromJson(json)).toList();
    return zoneList;
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
