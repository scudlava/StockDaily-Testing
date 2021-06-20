import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/dimens.dart';
import 'package:myfinancial/main.dart';
import 'package:myfinancial/routes/account/login.dart';
import 'package:myfinancial/routes/home/main_tab.dart';
import 'package:myfinancial/util/util.dart';
import 'package:myfinancial/util/widget/custom_widget.dart';

class Splash extends StatefulWidget{
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>{

  startTimer(BuildContext context) async{
    var duration = new Duration(seconds: 1);
    new Timer(duration, (){
      setState(() {
        try{
          UserProfile.fetch().then((value){
            if(value!=null){
              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder:(context) => TabHome()));
            }else{
              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder:(context) => LoginScreen()));
            }
          });
        }catch(e){
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder:(context) => LoginScreen()));
        }


      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: COLOR_PRIMARY,
      body: new Container(
        padding: EdgeInsets.all(padding_40),
        decoration: CustomWidget.bgAuth(),
        child: CustomWidget.itemLogo(),
        alignment: Alignment.center,
      ),
    );
  }

}