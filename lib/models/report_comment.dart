class ReportComment {
  final String userName;
  final String comment;
  final DateTime time;
  final String userAvatar;
  final int userid;

  ReportComment(
      {this.userName, this.comment, this.time, this.userAvatar, this.userid});

  ReportComment.fromJSON(Map<String, dynamic> json)
      : userName = json["username"] as String,
        comment = json["comment"] as String,
        time = DateTime.parse(json["submit_date"]),
        userAvatar = json["user_profile_image_url"] as String,
        userid = json["user"] as int;
}
