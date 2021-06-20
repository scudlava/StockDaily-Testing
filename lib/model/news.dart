class News{
  String url;
  String date;
  String title;
  String iconImage;

  News({
    this.title,
    this.date,
    this.url,
    this.iconImage,
  });

  factory News.fromJson(Map<String, dynamic> _json){
    return News(
      url : _json["url"] as String,
      title:_json["title"] as String,
      date:_json["date"] as String,
      iconImage:_json["iconImage"] as String,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "url":url,
        "title": title,
        "date": date,
        "iconImage": iconImage,
      };
}