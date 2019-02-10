class Crex24Model {
  final double last;
  final double percentChange;
  final double volume;
  final double high;
  final double low;
  final double bid;
  final double ask;

  Crex24Model(
      {this.last,
      this.percentChange,
      this.volume,
      this.high,
      this.low,
      this.bid,
      this.ask});

  Crex24Model.fromJson(Map json)
      : last = json['last'],
        percentChange = json['percentChange'],
        volume = json['baseVolume'],
        high = json['high'],
        low = json['low'],
        bid = json['bid'],
        ask = json['ask'];
}
