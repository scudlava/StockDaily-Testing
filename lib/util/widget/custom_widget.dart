import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/dimens.dart';
import 'package:myfinancial/model/company.dart';
import 'package:myfinancial/model/daily_price.dart';
import 'package:myfinancial/model/news.dart';
import 'package:myfinancial/routes/company/company_detail.dart';
import 'package:myfinancial/util/widget/custom_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nb_utils/nb_utils.dart';

import '../util.dart';

class CustomWidget{

  static Widget listNews(News news){
    return new InkWell(
      onTap: (){
        Utils.launchInBrowser("${news.url}");
      },
      child: new Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 0, right: 0, top: 15),
          height: 60,
          decoration: BoxDecoration(
              color: COLOR_WHITE,
              border: Border.all(color: COLOR_DIVIDER),
              //color: COLOR_LIGHT_GREY_F6,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: new Row(
            children: [
              new SizedBox(width: 5,),
              new ClipRect(
                  child:  CachedNetworkImage(
                    imageUrl: news.iconImage,
                    fit: BoxFit.fill,
                    height: 40,
                    width: 40,
                  ),
              ),
              new SizedBox(width: 10,),
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text("${news.title}", style: secondaryTextStyle(color: COLOR_TEXTCOLORSECONDARY, size: textSizeSMedium.toInt())),
                  new Flexible(child: new Container(
                    width:250,
                    child: CustomWidget.text('${news.title}',maxLine: 1, textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontBold),
                  )),

                  // Text("${news.date}", style: secondaryTextStyle(color: COLOR_TEXT_DATE, size: textizeSmall.toInt())),
                  CustomWidget.text('${news.date}', textColor: COLOR_DIVIDER, fontSize: textizeSmall, fontFamily: fontRegular),
                ],
              ),
            ],
          )
      ),
    );
  }

  static Widget lsitDailyFollow(BuildContext context,Company company){
    return new InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CompanyDetail(company: company,alreadyFollow: true,)));
      },
      child: new Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 0, right: 0, top: 15),
          height: 65,
          decoration: BoxDecoration(
              color: COLOR_WHITE,
              border: Border.all(color: COLOR_DIVIDER),
              //color: COLOR_LIGHT_GREY_F6,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Row(
                children: [
                  new SizedBox(width: 5,),
                  new ClipRect(
                    child:  CachedNetworkImage(
                      imageUrl: company.icon,
                      fit: BoxFit.fill,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  new SizedBox(width: 10,),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text("${news.title}", style: secondaryTextStyle(color: COLOR_TEXTCOLORSECONDARY, size: textSizeSMedium.toInt())),
                      CustomWidget.text('${company.simpleName}',maxLine: 1, textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontBold),

                      // Text("${news.date}", style: secondaryTextStyle(color: COLOR_TEXT_DATE, size: textizeSmall.toInt())),
                      CustomWidget.text('${company.name}', textColor: COLOR_DIVIDER, fontSize: textizeSmall, fontFamily: fontRegular),
                    ],
                  ),
                ],
              ),
              new Row(
                children: [
                  new SizedBox(width: 5,),
                  new ClipRect(
                    child:    Container(
                      height: 40.0,
                      width: 40.0,
                      child: Image(image: new AssetImage(company.variation==1 ?"assets/ic_chart_up.png":"assets/ic_down.png")),
                    )
                  ),
                  new SizedBox(width: 10,),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text("${news.title}", style: secondaryTextStyle(color: COLOR_TEXTCOLORSECONDARY, size: textSizeSMedium.toInt())),
                      CustomWidget.text('\$${company.dailyOpen}',maxLine: 1, textColor: company.variation==1 ?Colors.green:Colors.red, fontSize: textSizeSMedium, fontFamily: fontBold),

                      // Text("${news.date}", style: secondaryTextStyle(color: COLOR_TEXT_DATE, size: textizeSmall.toInt())),

                    ],
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }

  static Widget itemTopGainerAndLosers(Company company, int position){
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              width: 250.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                          child:  CachedNetworkImage(
                            imageUrl: company.icon,
                            fit: BoxFit.fill,
                            height: 40,
                            width: 40,
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: CustomWidget.text('${company.simpleName}', textColor: COLOR_TEXTCOLORPRIMARY, fontSize: textSizeLargeMedium, fontFamily: fontBold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: CustomWidget.text('\$123.3', textColor: COLOR_TEXT_Color_Secondary_V2, fontSize: textSizeMedium, fontFamily: fontRegular),
                        ),
                        new Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child:DecoratedBox(

                                  decoration: BoxDecoration(color: position % 2==0?COLOR_BACKGROUND_GREEN_TRANS:COLOR_BACKGROUND_PINK_TRANS, borderRadius: BorderRadius.all(Radius.circular(12))),
                                  child: new Padding(
                                    padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                    child: CustomWidget.text(position % 2==0?'+ \$15.04':'- \$42.11', textColor: position % 2==0?COLOR_BACKGROUND_GREEN:COLOR_BACKGROUND_PINK, fontSize: textSizeMedium, fontFamily: fontRegular),
                                  ),
                                )// Text("Testing", style: TextStyle(fontSize: 28.0),),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child:DecoratedBox(

                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
                                  child: new Padding(
                                    padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                    child: CustomWidget.text(position % 2==0?'+ \$20.01':'- \$12.23', textColor: COLOR_GREY, fontSize: textSizeMedium, fontFamily: fontRegular),
                                  ),
                                )// Text("Testing", style: TextStyle(fontSize: 28.0),),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
          ),
        )
    );
  }

  static BoxDecoration shadowDecoration({Color color,double circular=8.0,double blurRadius=4.0}){
    return new BoxDecoration(
        borderRadius: BorderRadius.circular(circular),
        color: color == null?COLOR_LIGHT_GREY_EEE:color,
        boxShadow: [
          new BoxShadow(
            color: Colors.black26,
            blurRadius: blurRadius,
          ),
        ]);
  }

  static Widget itemLogo() {
    return new Image(
      image: AssetImage('assets/icon_splash.png'),
      // image: AssetImage('assets/new_icon_splash.jpg'),
      fit: BoxFit.cover,
    );

  }

  static BoxDecoration bgAuth() {
    return new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage("assets/bg_auth.jpg"),
        fit: BoxFit.cover,
      ),
    );
  }

  static Widget text(var text,
      {var fontSize = textSizeLargeMedium,
        textColor = COLOR_TEXT_Color_Secondary_V2,
        var fontFamily = fontRegular,
        var isCentered = false,
        var maxLine = 1,
        var latterSpacing = 0.25,
        var isBold = false}) {
    return Text(text,
        textAlign: isCentered ? TextAlign.center : TextAlign.start,

        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,

        style: TextStyle(fontFamily: fontFamily, fontSize: fontSize, color: textColor, height: 1.5, letterSpacing: latterSpacing));
  }

  static Widget buildSearchSheet({Function onChangeFunc = null, TextEditingController controller}){
    TextFormField searchLocationField2 = new TextFormField(
      onChanged: onChangeFunc,
      controller: controller,
      decoration: InputDecoration(
          hintText: 'Search interest to follow',
          hintStyle: new TextStyle(color: COLOR_DIVIDER),
          prefixIcon: IconButton(
            icon: Icon(Icons.search),
            // icon: Icon(Icons.map),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_DIVIDER),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: COLOR_DIVIDER),
          ),
          border: InputBorder.none,
          fillColor: Colors.white,
          filled: true
      ),

    );
    return searchLocationField2;
  }
}


class Presentation {

  static TextStyle getStyle() {
    return TextStyle(inherit: false, color: Colors.black, fontSize: 16);
  }

  static Icon getIcon(int value, double size) {
    if (value == 1) {
      return Icon(
        Icons.arrow_upward,
        color: Colors.green,
        size: size,
      );
    } else if (value == -1) {
      return Icon(
        Icons.arrow_downward,
        color: Colors.red,
        size: size,
      );
    } else {
      return Icon(
        Icons.arrow_forward,
        color: Colors.blue,
        size: size,
      );
    }
  }

  static Row getRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Card(
            child: Text(
              key,
              style: getStyle(),
            ),
          ),
        ),
        Expanded(
            child: Card(
              child: Text(
                value,
                style: getStyle(),
              ),
            ))
      ],
    );
  }

  static Row getRowVariation(String key, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Card(
            child: Text(
              key,
              style: getStyle(),
            ),
          ),
        ),
        Expanded(
            child: Card(
              child: getIcon(value, 24.0),
            ))
      ],
    );
  }

  static FaIcon showCurrencySymbol(String string) {
    if (string == 'CAD') {
      return FaIcon(FontAwesomeIcons.dollarSign);
    } else if (string == 'USD') {
      return FaIcon(FontAwesomeIcons.dollarSign);
    } else if (string == 'EUR') {
      return FaIcon(FontAwesomeIcons.euroSign);
    } else if (string == 'GBP') {
      return FaIcon(FontAwesomeIcons.poundSign);
    } else if (string == 'YEN') {
      return FaIcon(FontAwesomeIcons.yenSign);
    } else {
      return FaIcon(FontAwesomeIcons.moneyBill);
    }
  }

  static SideTitles bottomTitles() {
    return SideTitles(
      showTitles: true,
      rotateAngle: 60,
      getTextStyles: (value) {
        return TextStyle(
          color: Colors.white,
        );
      },
      getTitles: (value) {
        return '';
      },
      margin: 8,
      interval: 25,
    );
  }

  static SideTitles leftTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (value) {
        return TextStyle(color: Colors.white, fontSize: 12);
      },
      getTitles: (value) => value.toString(),
      reservedSize: 28,
      margin: 12,
      interval: 40,
    );
  }

  static LineTouchData getLineTouchData(
      List<DailyPrice> liste, GlobalKey<CustomRowState> key) {
    return LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final FlSpot spot = barData.spots[spotIndex];
            if (spot.x == 0 || spot.x == 6) {
              return null;
            }
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.blue, strokeWidth: 4),
              FlDotData(show: true),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueAccent,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x == 0 || flSpot.x == 6) {
                  return null;
                }
                return LineTooltipItem(
                  '${liste[flSpot.x.toInt()].dailyClose}',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            }),
        touchCallback: (LineTouchResponse lineTouch) {
          // if (lineTouch.lineBarSpots.length == 1 &&
          //     lineTouch.touchInput is! FlLongPressEnd &&
          //     lineTouch.touchInput is! FlPanEnd) {
          //   final value = lineTouch.lineBarSpots;
          //   value.forEach((element) {
          //     key.currentState.updateDailyPrice(liste[element.spotIndex]);
          //
          //     //currentState.dailyPrice = ;
          //   });
          // } else {}
        });
  }

  static LineChartData mainData(List<DailyPrice> dailyPrices, BuildContext context, GlobalKey<CustomRowState> key) {
    const List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff23b6e6),
    ];
    List<FlSpot> spots = dailyPrices.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.dailyClose.toDouble());
    }).toList();
    return LineChartData(
      lineTouchData: Presentation.getLineTouchData(dailyPrices, key),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: Presentation.bottomTitles(),
        leftTitles: Presentation.leftTitles(),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: dailyPrices.length.toDouble() - 1,
      minY: 0,
      maxY: Utils.getMax(dailyPrices),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
            gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

}
