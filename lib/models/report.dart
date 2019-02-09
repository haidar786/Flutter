class Report {
  final int id;
  final String title;
  final String thumbnail;
  final String posterAvatar;
  final String posterUsername;
  final double latitude;
  final double longitude;
  final String zoneCity;
  final int views;
  final String timeAgo;
  final String solution;
  final String googleURL;
  final String reportEmralsAmount;
  final String solutionEmralsAmount;

  Report({
    this.id,
    this.title,
    this.thumbnail,
    this.posterAvatar,
    this.posterUsername,
    this.latitude,
    this.longitude,
    this.zoneCity,
    this.views,
    this.timeAgo,
    this.solution,
    this.googleURL,
    this.reportEmralsAmount,
    this.solutionEmralsAmount,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      posterAvatar: json['poster_avatar'] as String,
      posterUsername: json['poster_username'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      zoneCity: json['zone_city'] as String,
      views: json['views'] as int,
      timeAgo: json['time_ago'] as String,
      solution: json['solution'] as String,
      googleURL: json['google_url'] as String,
      reportEmralsAmount: json['report_emrals_amount'] as String,
      solutionEmralsAmount: json['solution_emrals_amount'] as String,
    );
  }
}
