import 'daily_price.dart';

class MetaDataObject {
  String symbol;
  String lastRefreshed;
  String timeZone;
  List<DailyPrice> timeSeries;
  String name;
  String currency;

  MetaDataObject({ this.symbol, this.lastRefreshed, this.timeZone, this.timeSeries, this.name, this.currency});
}