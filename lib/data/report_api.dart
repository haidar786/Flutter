import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:emrals/data/database_helper.dart';
import 'package:emrals/models/report.dart';
import 'package:emrals/models/user.dart';
import 'package:emrals/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class ReportApi {
  final _location = Location();
  final Client _httpClient = Client();

  Future<List<Report>> getReports({
    @required int offset,
    int limit = 50,
    @required ReportFilter reportFilter,
  }) async {
    List<Report> reportList;
    String reportListUrl;
    switch (reportFilter) {
      case ReportFilter.RECENT:
        reportListUrl = '$apiUrl/alerts/?limit=$limit&offset=$offset';
        break;
      case ReportFilter.CLOSEST:
        try {
          final LocationData currentLocation = await _location.getLocation();
          reportListUrl =
              '$apiUrl/alerts/?limit=$limit&offset=$offset&longitude=${currentLocation.longitude}&latitude=${currentLocation.latitude}';
        } on Exception catch (e) {
          print(e);
          throw Exception(e);
        }
        break;
    }
    final Response response = await _httpClient.get(reportListUrl);
    final Map data = json.decode(response.body);
    final List results = data['results'] as List;
    reportList = results.map<Report>((json) => Report.fromJson(json)).toList();
    return reportList;
  }

  Future<String> upload(
      String filename, double longitude, double latitude, User user) async {
    String result;
    File imageFile = File(filename);

    var stream = ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(apiUrl + "/upload/");

    var request = MultipartRequest("POST", uri);
    request.fields['longitude'] = longitude.toString();
    request.fields['latitude'] = latitude.toString();

    var multipartFile = MultipartFile(
      'file',
      stream,
      length,
      filename: basename(imageFile.path),
    );
    Map<String, String> headers = {"Authorization": "token " + user.token};

    request.headers.addAll(headers);
    request.files.add(multipartFile);

    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      if (value.contains('success')) {
        DatabaseHelper().deletereport(filename);
      }

      result = value;
    });
    return result;
  }
}

enum ReportFilter {
  RECENT,
  CLOSEST,
}
