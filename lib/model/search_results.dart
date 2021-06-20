class SearchResult {
  final String symbol;
  final String name;
  final String currency;
  final String region;

  SearchResult({this.symbol, this.name, this.currency, this.region});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
        symbol: json['1. symbol'],
        name: json['2. name'],
        currency: json['8. currency'],
        region: json['4. region']
    );
  }
}