class UserProfile {
  UserProfile(
    this._username,
    this._id,
    this._profileImageUrl,
    this._alertCount,
    this._cleanedCount,
    this._addedCount,
    this._earnedCount,
  );

  UserProfile.map(dynamic obj) {
    this._username = obj["username"];
    this._profileImageUrl = obj["profile_image_url"];
    this._id = obj["id"];
    this._alertCount = obj["alert_count"];
    this._addedCount = obj["added_count"];
    this._cleanedCount = obj["cleaned_count"];
    this._earnedCount = obj["earned_count"];
  }

  int _id;
  String _profileImageUrl;
  String _username;
  int _alertCount;
  int _cleanedCount;
  String _addedCount;
  String _earnedCount;

  String get username => _username;
  String get picture => _profileImageUrl;
  int get id => _id;
  int get alertCount => _alertCount;
  int get cleanedCount => _cleanedCount;
  String get addedCount => _addedCount;
  String get earnedCount => _earnedCount;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["username"] = _username;
    map["profile_image_url"] = _profileImageUrl;
    map["id"] = _id;
    map["alert_count"] = _alertCount;
    map["cleaned_count"] = _cleanedCount;
    map["added_count"] = _addedCount;
    map["earned_count"] = _earnedCount;

    return map;
  }

  // Profile.fromMap(Map<String, dynamic> map) {
  //   this._username = map["username"];
  //   this._profileImageUrl = map["profile_image_url"];
  //   this._id = map["id"];
  // }
}
