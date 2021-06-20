import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/dimens.dart';
import 'package:myfinancial/http/FirebaseUtil.dart';
import 'package:myfinancial/http/alpha_vantage.dart';
import 'package:myfinancial/model/company.dart';
import 'package:myfinancial/model/meta_data.dart';
import 'package:myfinancial/model/news.dart';
import 'package:myfinancial/util/util.dart';
import 'package:myfinancial/util/widget/custom_row.dart';
import 'package:myfinancial/util/widget/custom_widget.dart';

class CompanyDetail extends StatefulWidget{
  Company company;
  bool alreadyFollow=false;
  CompanyDetail({this.company,this.alreadyFollow});

  @override
  _CompanyDetailState createState() => _CompanyDetailState();

}

class _CompanyDetailState extends State<CompanyDetail>{
  final customRowKey = GlobalKey<CustomRowState>();
  List<News> listNewsItems = new List();

  void fetchListNews() async{
    listNewsItems = new List();
    FirebaseFirestore.instance.collection('news')
        .snapshots().listen(
            (data) {

          if(data.docs!=null){
            if(data.docs.isNotEmpty){
              // if(data.docs[0]['isValidate']==true){
              //   TabHome().launch(context);
              // }

              data.docs.forEach((value) {
                News news = new News(
                    date: value['date'],
                    url: value['url'],
                    iconImage: value['iconImage'],
                    title: value['title'],
                );
                print('add ${news.title}');
                listNewsItems.add(news);
              });


              if(mounted){
                setState(() {

                });
              }

            }



          }
        }


    );


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchListNews();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: COLOR_PRIMARY,
        body: SafeArea(
            child: Column(
                children: <Widget>[
                  Container(
                    height: 70,
                    margin: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                }),
                            SizedBox(width: 16),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomWidget.text('${widget.company.symbol}', textColor: COLOR_WHITE, fontSize: textSizeSMedium, fontFamily: fontMedium),
                                CustomWidget.text('${widget.company.simpleName}', textColor: COLOR_WHITE, fontSize: textSizeMedium, fontFamily: fontBold),
                              ],
                            )

                          ],
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.company.icon,
                          fit: BoxFit.fill,
                          height: 25,
                          width: 25,
                        ),
                        // SvgPicture.asset(
                        //   "assets/ic_news.svg",
                        //   width: 25,
                        //   height: 25,
                        //   color: COLOR_WHITE,
                        // )
                      ],
                    ),
                  ),

            new Expanded(child: new Container(
              decoration: BoxDecoration
                (
                  color: COLOR_WHITE,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)
                  )
              ),

              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Container(
                    height: 650,
                    child: new Container(
                      child: FutureBuilder(
                    future: AlphaVantage.getDailyTimeSeries(widget.company.symbol),
                    builder: (context, AsyncSnapshot<String> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                          decoration: BoxDecoration
                            (
                              color: COLOR_WHITE,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24)
                              )
                          ),
                          // color: Colors.white,
                          child: Center(child: CircularProgressIndicator()));
                    } else {
                      var json = jsonDecode(snapshot.data);
                      MetaDataObject meta = Utils.extractJson(json, widget.company.symbol, widget.company.name);
                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration
                              (
                                color: COLOR_WHITE,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24)
                                )
                            ),
                            child: new SingleChildScrollView(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 24, left: 24, top: 30, bottom: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[

                                      new Row(
                                        children: [

                                          CustomWidget.text('Stock (Daily)', textColor: COLOR_BLACK, fontSize: textSizeMedium, fontFamily: fontBold),
                                          Presentation.getIcon(meta.timeSeries.last.variation, 24.0),
                                        ],
                                      ),


                                      new Row(
                                        children: [
                                          CustomWidget.text('Open : ', textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontRegular),
                                          CustomWidget.text('\$${meta.timeSeries.last.dailyOpen.toString()}', textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontBold),
                                          new SizedBox(width: 10,),
                                          CustomWidget.text('Close : ', textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontRegular),
                                          CustomWidget.text('\$${meta.timeSeries.last.dailyClose.toString()}', textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontBold),

                                        ],
                                      ),

                                      new Row(
                                        children: [
                                          CustomWidget.text('Low : ', textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontRegular),
                                          CustomWidget.text('\$${meta.timeSeries.last.dailyLow.toString()}', textColor: Colors.red, fontSize: textSizeSMedium, fontFamily: fontBold),
                                          new SizedBox(width: 10,),
                                          CustomWidget.text('High : ', textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontRegular),
                                          CustomWidget.text('\$${meta.timeSeries.last.dailyHigh.toString()}', textColor: Colors.green, fontSize: textSizeSMedium, fontFamily: fontBold),
                                          new SizedBox(width: 10,),
                                          CustomWidget.text('Volume : ', textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontRegular),
                                          CustomWidget.text('${meta.timeSeries.last.dailyVolume.toString()}', textColor: COLOR_BLACK, fontSize: textSizeSMedium, fontFamily: fontBold),

                                        ],
                                      ),

                                      SizedBox(height: 20.0),
                                      Container(
                                        height: 150,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: Color(0xff232d37)),
                                        child: LineChart(
                                          Presentation.mainData(meta.timeSeries, context, customRowKey),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),



                                      TextButton(

                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(widget.alreadyFollow?COLOR_DIVIDER:COLOR_PRIMARY,),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(14.0),
                                                    side: BorderSide(color: widget.alreadyFollow?COLOR_DIVIDER:COLOR_PRIMARY,)
                                                )
                                            )
                                        ),
                                        onPressed: () async {
                                          if(widget.alreadyFollow){
                                            widget.alreadyFollow = false;
                                            await FirebaseUtil.unFollowCompany(widget.company);

                                          }else{
                                            widget.alreadyFollow = true;
                                            await FirebaseUtil.followCompany(widget.company);
                                          }

                                          if(mounted){
                                            setState(() {

                                            });
                                          }
                                        },
                                        child: CustomWidget.text( widget.alreadyFollow ? 'UnFollow':'Follow', textColor: widget.alreadyFollow? COLOR_PRIMARY:COLOR_WHITE, fontSize: textSizeMedium, fontFamily: fontBold),
                                        // color: COLOR_PRIMARY,
                                      ),

                                      SizedBox(
                                        height: 15.0,
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomWidget.text("News", textColor: COLOR_TEXT_PRIMARY, fontSize: textSizeMedium, fontFamily: fontBold),

                                        ],
                                      ),
                                      CustomScrollView(shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        slivers: <Widget>[
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                                  ( context,  index) {

                                                return listNewsItems.length > 0 ? CustomWidget.listNews(listNewsItems[index]) :
                                                Container();

                                              },
                                              childCount: listNewsItems.length ?? 0,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                    ),
                  ),


                ],
              ),
              //color: Colors.white,
            ),

            )
                ]
            )
        )
    );
  }
}