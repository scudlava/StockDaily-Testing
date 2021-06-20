//credit to https://github.com/jcmelend/flutter_alpha_vantage_api

import 'dart:async';

import 'package:myfinancial/util/alphavantage/BaseAPI.dart';
import 'package:myfinancial/util/alphavantage/JSONObject.dart';

class SectorPerformances extends BaseAPI {

  SectorPerformances(String key) : super(key);

  Future<JSONObject> getSectorPerformances() {
    return this.getRequest(function: "SECTOR");
  }
}