import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/dimens.dart';
import 'package:myfinancial/http/alpha_vantage.dart';
import 'package:myfinancial/model/company.dart';
import 'package:myfinancial/model/meta_data.dart';
import 'package:myfinancial/model/user_account.dart';
import 'package:myfinancial/util/util.dart';
import 'package:myfinancial/util/widget/custom_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>{
  String greeting = "";

  List<Company> listAlreadyFollow = new List();
  List<Company> listCompanyDummy = new List();

  ScrollController scrollController;
  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;

  void fetchListCompany() async{
    FirebaseFirestore.instance.collection('symbollist')
        .snapshots().listen(
            (data) {

          if(data.docs!=null){
            if(data.docs.isNotEmpty){
              data.docs.forEach((value) {
                Company company = new Company(
                    id: value.id,
                    symbol: value['symbol'],
                    name: value['name'],
                    simpleName: value['simpleName'],
                    icon: value['icon'],
                    country: value['country']
                );
                listCompanyDummy.add(company);
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

  void fetchlistAlreadyFollow() async{
    listAlreadyFollow = new List();
    UserAccount user = await UserProfile.fetch();
    print('UserId : ${user.id}');
    FirebaseFirestore.instance.collection('users').doc(user.id).collection('listfollow')
        .snapshots().listen((data) {


          if(data.docs!=null){
            if(data.docs.isNotEmpty){
              listAlreadyFollow = new List();
              data.docs.forEach((value) {
                print('Symbol : ${value['symbol']}');
                AlphaVantage.getDailyTimeSeries(value['symbol']).then((snapshot) {
                  var json = jsonDecode(snapshot);
                  MetaDataObject meta = Utils.extractJson(json, value['symbol'], value['name']);
                  // meta.timeSeries.last.dailyOpen;
                  Company company = new Company(
                      id: value.id,
                      symbol: value['symbol'],
                      name: value['name'],
                      simpleName: value['simpleName'],
                      icon: value['icon'],
                      country: value['country'],
                      dailyOpen: meta.timeSeries.last.dailyOpen,
                      variation: meta.timeSeries.last.variation
                  );



                  listAlreadyFollow.add(company);

                  if(mounted){
                    setState(() {

                    });
                  }

                });


              });


            }



          }
        }


    );


  }

  void getGreeting() async{
    greeting = await Utils.greeting();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = new ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getGreeting();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchListCompany();
    fetchlistAlreadyFollow();
  }

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
                      CustomWidget.text( "Hi, $greeting", textColor: COLOR_WHITE, fontSize: textSizeMedium, fontFamily: fontMedium)
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding : const EdgeInsets.only(left: 24.0, right: 24.0),
                          child:  CustomWidget.text("TOP Gainers & Losers", textColor: COLOR_TEXT_PRIMARY, fontSize: textSizeSMedium, fontFamily: fontBold),
                        ),

                      ],
                    ),
                    SizedBox(height: 15),
                    AspectRatio(
                      aspectRatio: 16/9,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: CustomWidget.shadowDecoration(color: COLOR_LIGHT_GREY_F6),
                        child:  Padding(
                          padding: const EdgeInsets.all(0),
                          child: ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: listCompanyDummy.length,
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, position) {

                              return CustomWidget.itemTopGainerAndLosers(listCompanyDummy[position], position);
                            },


                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding : const EdgeInsets.only(left: 24.0, right: 24.0),
                          child:  CustomWidget.text("Daily Stock (Follow)", textColor: COLOR_TEXT_PRIMARY, fontSize: textSizeSMedium, fontFamily: fontBold),
                        ),
                      ],
                    ),

                    CustomScrollView(shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                ( context,  index) {

                              return listAlreadyFollow.length > 0 ? CustomWidget.lsitDailyFollow(context,listAlreadyFollow[index]) :
                              Container();

                            },
                            childCount: listAlreadyFollow.length ?? 0,
                          ),
                        ),
                      ],
                    ),

                    new SizedBox(height: 350,),


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