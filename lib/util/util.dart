import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/model/daily_price.dart';
import 'package:myfinancial/model/meta_data.dart';
import 'package:myfinancial/model/user_account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:math';


changeStatusColor(Color color, {bool isWhite = true}) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  } on Exception catch (e) {
    print(e);
  }
}

class Utils{
  static Future<Null> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
  static Future<String> greeting() async{
    String frontName = "";
    UserAccount value = await UserProfile.fetch();

    if(value!=null){
      frontName = value.frontName;

    }

    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning'+(frontName != ''? '! '+frontName:'');
    }
    if (hour < 17) {
      return 'Good Afternoon'+(frontName != ''? '! '+frontName:'');
    }
    return 'Good Evening'+(frontName != ''? '! '+frontName:'');


  }

  static void showToast(BuildContext context, String message,{Color color = COLOR_RED_V2}) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }

  static getVariations(List<DailyPrice> liste) {
    for (var i = 0; i < liste.length; i++) {
      if (i == 0) {
        liste[i].variation = 0;
      } else {
        var variation = liste[i].dailyClose - liste[i - 1].dailyClose;
        liste[i].variation = variation < 0
            ? -1
            : variation == 0
            ? 0
            : 1;
      }
    }
  }

  static MetaDataObject extractJson(dynamic json, String symbol, String name) {
    var lastRefreshed = json['Meta Data']['3. Last Refreshed'];
    var timeZone = json['Meta Data']['5. Time Zone'];
    var time = json['Time Series (Daily)'] as Map<String, dynamic>;
    List<DailyPrice> liste = [];
    time.entries.forEach((element) {
      liste.add(DailyPrice.fromJson(element.value, element.key));
    });
    liste = liste.reversed.toList();
    getVariations(liste);
    return MetaDataObject(
        lastRefreshed: lastRefreshed,
        symbol: symbol,
        timeSeries: liste,
        timeZone: timeZone,
        name: name);
  }

  static double getMax(List<DailyPrice> liste) {
    //liste.reduce((curr, next) => curr > next? curr: next))
    List<double> maxValue =
    liste.asMap().entries.map((e) => e.value.dailyClose).toList();

    return maxValue.reduce(max) * 1.2;
  }

  static double getMin(List<DailyPrice> liste) {
    //liste.reduce((curr, next) => curr < next? curr: next))
    List<double> maxValue =
    liste.asMap().entries.map((e) => e.value.dailyClose).toList();
    return maxValue.reduce(min);
  }

  static double getAvg(List<DailyPrice> liste) {
    return (getMax(liste) + getMin(liste)) / 2.round();
  }
}

class UserProfile {
  static const PROFILE_KEY = 'profile';

  static Future<Null> save(UserAccount userAccount) async {
    String strJson = json.encode(userAccount);

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PROFILE_KEY, strJson);
  }



  static Future<Null> clear() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PROFILE_KEY, '');
  }

  static Future<UserAccount> fetch() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String strJson = _prefs.getString(PROFILE_KEY);
    if(strJson!=null){
      Map<String, dynamic> data = json.decode(strJson);
      return UserAccount.fromJson(data);
    }else{
      return null;
    }

  }






}