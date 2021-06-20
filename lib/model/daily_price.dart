
class DailyPrice {
  final String dailyDate;
  final double dailyOpen;
  final double dailyHigh;
  final double dailyLow;
  final double dailyClose;
  final int dailyVolume;
  int variation;

  DailyPrice(
      {this.dailyDate,
        this.dailyOpen,
        this.dailyHigh,
        this.dailyLow,
        this.dailyClose,
        this.dailyVolume});

  factory DailyPrice.fromJson(Map<String, dynamic> json, String key) {
    return DailyPrice(
        dailyDate: key,
        dailyOpen: double.parse(json['1. open']),
        dailyClose: double.parse(json['4. close']),
        dailyHigh: double.parse(json['2. high']),
        dailyLow: double.parse(json['3. low']),
        dailyVolume: int.parse(json['6. volume']));
  }
}