import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/dimens.dart';
import 'package:myfinancial/util/util.dart';
import 'package:myfinancial/util/widget/custom_widget.dart';

class Portopolio extends StatefulWidget{
  @override
  _PortopolioState createState() => _PortopolioState();
}

class _PortopolioState extends State<Portopolio>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: COLOR_PRIMARY,
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: 70,
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CustomWidget.text( "Portfolio", textColor: COLOR_WHITE, fontSize: textSizeMedium, fontFamily: fontMedium)
                    ],
                  ),
                  SvgPicture.asset(
                    "assets/ic_option.svg",
                    width: 25,
                    height: 25,
                    color: COLOR_WHITE,
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 100),

              child: Container(
                padding: EdgeInsets.only(top: 28),
                alignment: Alignment.topLeft,
//                height: MediaQuery.of(context).size.height - 100,
                decoration: BoxDecoration(
                    color: COLOR_WHITE,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)
                    )
                ),
                child: Column(
                  //body ui
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    new Container(),
                    SizedBox(height: 15),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding : const EdgeInsets.only(left: 24.0, right: 24.0),
                    //       child:  CustomWidget.text("TOP Gainers & Losers", textColor: COLOR_TEXT_PRIMARY, fontSize: textSizeMedium, fontFamily: fontBold),
                    //     ),
                    //
                    //   ],
                    // ),
                    // SizedBox(height: 15),
                    // AspectRatio(
                    //   aspectRatio: 16/8,
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     decoration: CustomWidget.shadowDecoration(color: COLOR_LIGHT_GREY_F6),
                    //     child:  Padding(
                    //       padding: const EdgeInsets.all(24.0),
                    //       child: new Container(),//Db4GridListing(mFavouriteList, false,false),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 15),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding : const EdgeInsets.only(left: 24.0, right: 24.0),
                    //       child:  CustomWidget.text("Whistlists", textColor: COLOR_TEXT_PRIMARY, fontSize: textSizeMedium, fontFamily: fontBold),
                    //     ),
                    //   ],
                    // ),

                    new SizedBox(height: 650,),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
//      bottomNavigationBar: Db4BottomBar(),
    );
  }
}