class ReportComment {
  final String userName;
  final String comment;
  final DateTime time;
  final String userAvatar;
  final int userid;

  ReportComment(
      {this.userName, this.comment, this.time, this.userAvatar, this.userid});

  ReportComment.fromJSON(Map<String, dynamic> json)
      : userName = json["user_name"] as String,
        comment = json["comment"] as String,
        time = json["time"] as DateTime,
        userAvatar = json["avatar"] as String,
        userid = json["user_id"] as int;
}
