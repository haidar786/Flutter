class Report {
  final int id;
  final String title;
  final String thumbnail;
  final String posterAvatar;
  final String posterUsername;

  Report({
    this.id,
    this.title,
    this.thumbnail,
    this.posterAvatar,
    this.posterUsername,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      posterAvatar: json['poster_avatar'] as String,
      posterUsername: json['poster_username'] as String,
    );
  }
}
