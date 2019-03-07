class User {
  User(
    this._username,
    this._token,
    this._emrals,
    this._id,
    this._picture,
    this._xp,
    this._emralsAddress,
  );

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._token = obj["token"] ?? obj["key"];
    this._emrals = double.parse(obj["emrals"].toString());
    this._picture = obj["picture"];
    this._xp = obj["xp"];
    this._id = obj["id"];
    this._emralsAddress = obj["emrals_address"];
  }

  double _emrals = 0;
  int _id;
  String _picture;
  String _token;
  String _username;
  String _emralsAddress;

  int _xp;

  String get username => _username;

  String get token => _token;

  String get picture => _picture;

  int get id => _id;

  int get xp => _xp;

  String get emralsAddress => _emralsAddress;

  double get emrals => _emrals;

  // set emrals(double emrals) {
  //   _emrals = emrals;
  // }

  set emrals(double value) {
    if (value == null) {
      throw new ArgumentError();
    }
    _emrals = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["username"] = _username;
    map["token"] = _token;
    map["picture"] = _picture;
    map["id"] = _id;
    map["xp"] = _xp;
    map["emrals"] = _emrals;
    map["emrals_address"] = _emralsAddress;
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._username = map["username"];
    this._token = map["token"];
    this._emrals = map["emrals"];
    this._picture = map["picture"];
    this._xp = map["xp"];
    this._id = map["id"];
    this._emralsAddress = map["emrals_address"];
  }
}
