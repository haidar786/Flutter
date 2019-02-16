import 'package:url_launcher/url_launcher.dart';

class Report {
  final int id;
  final String title;
  final int creator;
  final String thumbnail;
  final String posterAvatar;
  final String posterUsername;
  final double latitude;
  final double longitude;
  final String zoneCity;
  final int views;
  final String timeAgo;
  final String slug;
  final String solution;
  final String googleURL;
  String reportEmralsAmount;
  final String solutionEmralsAmount;

  Report({
    this.id,
    this.title,
    this.creator,
    this.thumbnail,
    this.posterAvatar,
    this.posterUsername,
    this.latitude,
    this.longitude,
    this.zoneCity,
    this.views,
    this.timeAgo,
    this.slug,
    this.solution,
    this.googleURL,
    this.reportEmralsAmount,
    this.solutionEmralsAmount,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      title: json['title'] as String,
      creator: json['creator'] as int,
      thumbnail: json['thumbnail'] as String,
      posterAvatar: json['poster_avatar'] as String,
      posterUsername: json['poster_username'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      zoneCity: json['zone_city'] as String,
      views: json['views'] as int,
      slug: json['slug'] as String,
      timeAgo: json['time_ago'] as String,
      solution: json['solution'] as String,
      googleURL: json['google_url'] as String,
      reportEmralsAmount: json['report_emrals_amount'] as String,
      solutionEmralsAmount: json['solution_emrals_amount'] as String,
    );
  }

  launchMaps() async {
    String googleUrl = 'geo:0,0?q=$latitude,$longitude';
    String googleiOSUrl = 'googlemaps://?q=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
    if (await canLaunch("geo://")) {
      print('launching com googleUrl' + googleUrl);
      await launch(googleUrl);
    } else if (await canLaunch(googleiOSUrl)) {
      print('launching apple url' + googleiOSUrl);
      await launch(googleiOSUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url' + appleUrl);
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }
}
