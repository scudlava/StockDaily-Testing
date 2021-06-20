import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/dimens.dart';
import 'package:myfinancial/http/FirebaseUtil.dart';
import 'package:myfinancial/http/algolia_application.dart';
import 'package:myfinancial/model/company.dart';
import 'package:myfinancial/model/user_account.dart';
import 'package:myfinancial/routes/company/company_detail.dart';
import 'package:myfinancial/util/util.dart';
import 'package:myfinancial/util/widget/custom_widget.dart';

class InterestScreen extends StatefulWidget{
  @override
  _InterestState createState() => _InterestState();
}

class _InterestState extends State<InterestScreen>{
  List<Company> listItemCompany = new List();
  List<String> listAlreadyFollow = new List();
  TextEditingController searchCont = new TextEditingController();

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;
  bool isTyping = false;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("symbollist").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   fetchListCompany();
    //
    // });
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchListCompany();
    // _apiRequest = APIRequest.create(context);
  }

  Widget listWidget(Company company){
    bool alreadyFollow =  isAlreadyFollow(company.symbol);
    return new InkWell(onTap:(){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => CompanyDetail(company: company,alreadyFollow: alreadyFollow,)));
    },child: Container(
      alignment: Alignment.center,
      child:new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CachedNetworkImage(
            imageUrl: company.icon,
            fit: BoxFit.fill,
            height: 40,
            width: 40,
          ),

          CustomWidget.text( company.simpleName, textColor: COLOR_BLACK, fontSize: textSizeMedium, fontFamily: fontBold),
          new SizedBox(height: 10,),

          TextButton(

            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(alreadyFollow?COLOR_DIVIDER:COLOR_PRIMARY,),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        side: BorderSide(color: alreadyFollow?COLOR_DIVIDER:COLOR_PRIMARY,)
                    )
                )
            ),
            onPressed: () {
              if(alreadyFollow){
                FirebaseUtil.unFollowCompany(company);
              }else{
                FirebaseUtil.followCompany(company);
              }
            },
            child: CustomWidget.text( alreadyFollow ? 'UnFollow':'Follow', textColor: alreadyFollow? COLOR_PRIMARY:COLOR_WHITE, fontSize: textSizeMedium, fontFamily: fontBold),
            // color: COLOR_PRIMARY,
          ),

          // RaisedButton(
          //   padding: EdgeInsets.all(12),
          //   onPressed: () {
          //     if(alreadyFollow){
          //       FirebaseUtil.unFollowCompany(company);
          //     }else{
          //       FirebaseUtil.followCompany(company);
          //     }
          //   },
          //   color: alreadyFollow?COLOR_DIVIDER:COLOR_PRIMARY,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          //   child: CustomWidget.text( alreadyFollow ? 'UnFollow':'Follow', textColor: alreadyFollow? COLOR_PRIMARY:COLOR_WHITE, fontSize: textSizeMedium, fontFamily: fontBold),
          // ),
          new SizedBox(height: 5,)
        ],
      ),

      decoration: BoxDecoration(
          color: COLOR_WHITE,
          border: Border.all(color: COLOR_DIVIDER),
          borderRadius: BorderRadius.circular(12)),
    )
    );
  }

  void fetchListCompany() async{
    FirebaseFirestore.instance.collection('symbollist')
        .snapshots().listen(
            (data) {

          if(data.docs!=null){
            if(data.docs.isNotEmpty){
              // if(data.docs[0]['isValidate']==true){
              //   TabHome().launch(context);
              // }

              data.docs.forEach((value) {
                Company company = new Company(
                    id: value.id,
                    symbol: value['symbol'],
                    name: value['name'],
                    simpleName: value['simpleName'],
                    icon: value['icon'],
                    country: value['country']
                );
                // Map<String, dynamic> data = {
                //   "id": value.id,
                //   "symbol": value['symbol'],
                //   "name": value['name'],
                //   "simpleName": value['simpleName'],
                //   "icon": value['icon'],
                //   "country": value['country']
                // };
                // _algoliaApp.instance.index("symbollist").addObject(data);

                listItemCompany.add(company);
              });

            }

            print('email ${data.docs[0]['country']}');

            fetchListFollow().then((value) {

              setState(() {

              });
            });

          }
        }


    );


  }

  Future<void> fetchListFollow() async{
    UserAccount user = await UserProfile.fetch();
    print('UserId : ${user.id}');
    FirebaseFirestore.instance.collection('users').doc(user.id).collection('listfollow')
        .snapshots().listen((data) {
      print('size : ${data.docs.length}');
      listAlreadyFollow = new List();
      data.docs.forEach((element) {
        print('Symbol : ${element['symbol']}');
        listAlreadyFollow.add(element['symbol']);
      });

      if(mounted){
        setState(() {

        });
      }


    });
  }

  bool isAlreadyFollow(String symbol){
    print('Size: ${listAlreadyFollow.length}');
    print('SymbolCheck : $symbol contains: ${listAlreadyFollow.contains(symbol)}');
    // if(listAlreadyFollow.contains(symbol)){
    //   return true;
    // }else{
    //   return false;
    // }
    var isFound = false;
    for(int i=0;i<listAlreadyFollow.length;i++){
      if(listAlreadyFollow[i] == symbol){
        isFound = true;
        break;
      }
    }

    return isFound;
  }

  void onSearchInput(String val){
    // setState(() {
    //   _searchTerm = val;
    // });
    isTyping = true;
    _searchTerm = val;
    setState(() {
      searchCont.text = _searchTerm;
    });
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
                      CustomWidget.text( "Choose your interest to follow and trade", textColor: COLOR_WHITE, fontSize: textSizeMedium, fontFamily: fontMedium)
                    ],
                  ),

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
                    new Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: CustomWidget.buildSearchSheet(controller: searchCont,onChangeFunc: onSearchInput)
                    ),

                    new SizedBox(height: 15,),

                    !isTyping?new Container(): new Container(
                        height:500 ,
                        child: new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StreamBuilder<List<AlgoliaObjectSnapshot>>(
                            stream: Stream.fromFuture(_operation(_searchTerm)),
                            builder: (context, snapshot) {
                              if(!snapshot.hasData) return Text("Load data....", style: TextStyle(color: Colors.black ),);
                              else{
                                List<AlgoliaObjectSnapshot> currSearchStuff = snapshot.data;
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return Container();
                                  default:
                                    if (snapshot.hasError)
                                      return new Text('Error: ${snapshot.error}');
                                    else
                                      return GridView.builder(
                                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200,
                                              childAspectRatio: 3 / 3,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                          itemCount: currSearchStuff.length,
                                          itemBuilder: (BuildContext ctx, index) {
                                            Company company = new Company(
                                                id: currSearchStuff[index].data["id"],
                                                symbol: currSearchStuff[index].data["symbol"],
                                                name: currSearchStuff[index].data["name"],
                                                simpleName: currSearchStuff[index].data["simpleName"],
                                                icon: currSearchStuff[index].data["icon"],
                                                country: currSearchStuff[index].data["country"]);
                                            return listWidget(company);
                                          });
                                // return CustomScrollView(shrinkWrap: true,
                                //   slivers: <Widget>[
                                //     SliverList(
                                //       delegate: SliverChildBuilderDelegate(
                                //             ( context,  index) {
                                //
                                //               Company company = new Company(
                                //                   id: currSearchStuff[index].data["id"],
                                //                   symbol: currSearchStuff[index].data["symbol"],
                                //                   name: currSearchStuff[index].data["name"],
                                //                   simpleName: currSearchStuff[index].data["simpleName"],
                                //                   icon: currSearchStuff[index].data["icon"],
                                //                   country: currSearchStuff[index].data["country"]);
                                //
                                //           return _searchTerm.length > 0 ? listWidget(company) :
                                //           Container();
                                //
                                //         },
                                //         childCount: currSearchStuff.length ?? 0,
                                //       ),
                                //     ),
                                //   ],
                                // );
                                }
                              }
                            },
                          ),

                        )
                    ),

                    isTyping ? new Container():new Container(height:500 ,child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: listItemCompany.length!=0 ? GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                          itemCount: listItemCompany.length,
                          itemBuilder: (BuildContext ctx, index) {
                            bool alreadyFollow = isAlreadyFollow(listItemCompany[index].symbol);
                            Company company = new Company(
                                id: listItemCompany[index].id,
                                symbol: listItemCompany[index].symbol,
                                name: listItemCompany[index].name,
                                simpleName: listItemCompany[index].simpleName,
                                icon: listItemCompany[index].icon,
                                country: listItemCompany[index].country);
                            return listWidget(company);
                            // return new InkWell(onTap:(){
                            //   Navigator.push(context, MaterialPageRoute(
                            //       builder: (context) => CompanyDetail(company: listItemCompany[index],)));
                            // },child: Container(
                            //   alignment: Alignment.center,
                            //   child:new Column(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //
                            //       CachedNetworkImage(
                            //         imageUrl: listItemCompany[index].icon,
                            //         fit: BoxFit.fill,
                            //         height: 40,
                            //         width: 40,
                            //       ),
                            //
                            //       CustomWidget.text( listItemCompany[index].simpleName, textColor: COLOR_BLACK, fontSize: textSizeMedium, fontFamily: fontBold),
                            //       new SizedBox(height: 10,),
                            //       RaisedButton(
                            //         padding: EdgeInsets.all(12),
                            //         onPressed: () {
                            //           // Utils.showToast(context, 'Clicked');
                            //           alreadyFollow?(){
                            //             FirebaseUtil.unFollowCompany(listItemCompany[index]);
                            //           }:FirebaseUtil.followCompany(listItemCompany[index]);
                            //         },
                            //         color: alreadyFollow?COLOR_DIVIDER:COLOR_PRIMARY,
                            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            //         child: CustomWidget.text( alreadyFollow ? 'UnFollow':'Follow', textColor: alreadyFollow? COLOR_PRIMARY:COLOR_WHITE, fontSize: textSizeMedium, fontFamily: fontBold),
                            //       ),
                            //       new SizedBox(height: 5,)
                            //     ],
                            //   ),
                            //
                            //   decoration: BoxDecoration(
                            //       color: COLOR_WHITE,
                            //       border: Border.all(color: COLOR_DIVIDER),
                            //       borderRadius: BorderRadius.circular(12)),
                            // )
                            // );
                          })
                          : new Container(),
                    ),
                    ),



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