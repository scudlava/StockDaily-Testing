class Company{
  String id;
  String symbol;
  String name;
  String simpleName;
  String icon;
  String country;
  double dailyOpen;
  int variation;

  Company({this.id, this.symbol, this.name, this.simpleName, this.icon, this.country,this.dailyOpen, this.variation});


  factory Company.fromJson(Map<String, dynamic> _json){
    return Company(
      id : _json["id"] as String,
      symbol:_json["symbol"] as String,
      name:_json["name"] as String,
      simpleName:_json["simpleName"] as String,
      icon:_json["icon"] as String,
      country:_json["country"] as String,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "id":id,
        "symbol": symbol,
        "name": name,
        "simpleName": simpleName,
        "icon": icon,
        "country": country
      };
}