class Zone {
  final int id;
  final String city;
  final String country;
  final String slug;
  final double latitude;
  final double longitude;
  final int views;
  final String image;
  final String emralsAddress;
  final String emralsAmount;
  final String flag;
  final int subscriberCount;
  final int cleanupCount;
  final int reportCount;

  Zone({
    this.id,
    this.city,
    this.country,
    this.slug,
    this.latitude,
    this.longitude,
    this.views,
    this.image,
    this.emralsAddress,
    this.emralsAmount,
    this.flag,
    this.subscriberCount,
    this.cleanupCount,
    this.reportCount,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] as int,
      city: json['city'] as String,
      country: json['country'] as String,
      slug: json['slug'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      views: json['views'] as int,
      image: json['image'] as String,
      emralsAddress: json['emrals_address'] as String,
      emralsAmount: json['emrals_amount'] as String,
      flag: json['flag'] as String,
      subscriberCount: json['subscriber_count'] as int,
      cleanupCount: json['cleanup_count'] as int,
      reportCount: json['report_count'] as int,
    );
  }
}
