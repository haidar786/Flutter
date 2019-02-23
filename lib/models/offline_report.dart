class OfflineReport {
  OfflineReport(
    //this.id,
    this._filename,
    this._latitude,
    this._longitude,
  );

  OfflineReport.map(dynamic obj) {
    this._filename = obj["filename"];
    this._latitude = obj["latitude"];
    this._longitude = obj["longitude"];
  }

  String _filename;
  double _latitude;
  double _longitude;

  String get filename => _filename;
  double get latitude => _latitude;
  double get longitude => _longitude;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    //map["id"] = id;
    map["filename"] = filename;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    return map;
  }

  OfflineReport.fromMap(Map<String, dynamic> map) {
    this._filename = map["filename"];
    this._latitude = map["latitude"];
    this._longitude = map["longitude"];
  }
}
