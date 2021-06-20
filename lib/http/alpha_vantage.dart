
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfinancial/model/search_results.dart';

const String BASE_URL = "https://www.alphavantage.co/query?function=";
String apiKey = "ASC76E7P9QZDCUEQ";


class AlphaVantage {

  static Future<List<SearchResult>> executeSearch(String query) async {
    final client = http.Client();
    Uri uri = Uri.parse(BASE_URL+"SYMBOL_SEARCH&keywords=$query&apikey=$apiKey");
    var response = await client.get(uri);
    //var response = await client.get("https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords="+query+"&apikey="+apiKey);
    if(response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['bestMatches'];
      List<SearchResult> searchResults = body
          .map((dynamic item) => SearchResult.fromJson(item))
          .toList();
      return searchResults;
    }
    else {
      throw "Can't get results";
    }
  }

  static Future<String> getDailyTimeSeries(String symbol) async {
    final client = http.Client();
    //var response = await client.get(BASE_URL+"TIME_SERIES_DAILY_ADJUSTED&symbol="+symbol+"&apikey="+apiKey);
    Uri uri = Uri.parse(BASE_URL+"TIME_SERIES_DAILY_ADJUSTED&symbol=$symbol&apikey=$apiKey");
    var response = await client.get(uri);
    //print(apiKey);
    if(response.statusCode == 200) {
      return response.body.toString();
    }
    else {
      throw "Can't get Time Series";
    }
  }

  static Future<String> getOverview(String symbol) async {
    final client = http.Client();
    //var response = await client.get(BASE_URL+"OVERVIEW&symbol="+symbol+"&apikey="+apiKey);
    Uri uri = Uri.parse(BASE_URL+"OVERVIEW&symbol=$symbol&apikey=$apiKey");
    var response = await client.get(uri);
    if(response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw "Can't get Overview";
    }
  }
}

//Search endpoint
//https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=tesco&apikey=demo

//overview
//https://www.alphavantage.co/query?function=OVERVIEW&symbol=IBM&apikey=demo

//Time series adjusted
//https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=IBM&apikey=demo

// java okhttp
/* Request request = new Request.Builder()
	.url("https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=TSLA")
	.get()
	.addHeader("x-rapidapi-key", "")
	.addHeader("x-rapidapi-host", "alpha-vantage.p.rapidapi.com")
	.build(); */
