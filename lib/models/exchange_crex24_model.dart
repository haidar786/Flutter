class Crex24Model {
  final double last;
  final double percent_change;
  final double volume;
  final double high;
  final double low;
  final double bid;
  final double ask;

  Crex24Model.fromJson(Map json) 
      : last = json['last'],
      percent_change = json['percentChange'],
      volume = json['baseVolume'],
      high = json['high'],
      low = json['low'],
      bid = json['bid'],
      ask = json['ask'];
}
