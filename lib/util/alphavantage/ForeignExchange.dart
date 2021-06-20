//credit to https://github.com/jcmelend/flutter_alpha_vantage_api

import 'dart:async';

import 'package:myfinancial/util/alphavantage/BaseAPI.dart';
import 'package:myfinancial/util/alphavantage/JSONObject.dart';

class ForeignExchange extends BaseAPI {

  ForeignExchange(String key) : super(key);


  Future<JSONObject> getCurrencyExchangeRate(String fromCurrency, String toCurrency) {
    return this.getRequest(function: "CURRENCY_EXCHANGE_RATE", fromCurrency: fromCurrency, toCurrency: toCurrency );

  }
}