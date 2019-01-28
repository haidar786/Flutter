class Report {
  final int id;
  final String title;
  final String thumbnail;

  Report({this.id, this.title, this.thumbnail});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
    );
  }
}