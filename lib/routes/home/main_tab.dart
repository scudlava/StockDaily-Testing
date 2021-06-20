import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myfinancial/constant/colors.dart';
import 'package:myfinancial/constant/dimens.dart';
import 'package:myfinancial/routes/home/dashboard.dart';
import 'package:myfinancial/routes/home/portopolio.dart';
import 'package:myfinancial/routes/interest/interest.dart';

import '../../app_config.dart';

class TabHome extends StatefulWidget{
  @override
  _TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome>{
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final _myTabbedPageKey = new GlobalKey();

  int _currentIndex = 0;


  void goToHome() {
    Navigator.pop(context);
    setState(() {
      _currentIndex = 0;
    });
  }

  ApplicationConfig config;

  List<String> appbarTitles;
  List<Widget> appbarWidgets;
  List<String> appbarWidgetsEventName;

  bool _updateAppRequired = false;

  BottomNavigationBarItem createIcon(String icon, String iconActive, String label) {
    return new BottomNavigationBarItem(
        activeIcon: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(iconActive),
        ),
        icon: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(icon),
        ),
        title: Text(
          label,
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800),
        ));
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appbarWidgets = [
      Dashboard(),
      InterestScreen()
      // Portopolio()
    ];
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    final BottomAppBar bottomAppBar = new BottomAppBar(
//      child: Row(
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//
//        ],
//      ),
//      shape: CircularNotchedRectangle(),
//      color: Colors.blueGrey,
//    );

//  final bottomAppBar = new FABBottomAppBar(
//    onTabSelected: (int newValue){
//      setState(() {
//        _currentIndex = newValue;
//      });
//    },
//    backgroundColor: Colors.white,
//    selectedColor: COLOR_BASE,
//    notchedShape: CircularNotchedRectangle(),
////    onTabSelected: _currentIndex,
//    items: [
//      FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
//      FABBottomAppBarItem(iconData: Icons.message, text: 'News'),
//      FABBottomAppBarItem(iconData: Icons.perm_media, text: 'Sosmed'),
//      FABBottomAppBarItem(iconData: Icons.account_box, text: 'Profile'),
//    ],
//  );

    final bottomAppBarV2 = Db4BottomBar(
      onTabSelected: (int newValue){
        setState(() {
          _currentIndex = newValue;
        });
      },
    );


    return new WillPopScope(
      onWillPop: () async {
        if(_currentIndex!=0){
          if(mounted){
            setState(() {
              _currentIndex=0;
            });
          }
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
//        body: new Column(
//          children: <Widget>[
//            new Text('test')
//          ],
//        ),
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> Panic()));
//          },
//          tooltip: 'Tombol Panic',
//          child: Icon(Icons.report),
//          backgroundColor: Colors.red,
//          elevation: 2.0,
//        ),
        body: appbarWidgets[_currentIndex],
        bottomNavigationBar: bottomAppBarV2,
      ),
    );

//    return Scaffold(
//      key: _scaffoldKey,
//      appBar: CustomWidget.buildDefaultAppBar(title: appbarTitles[_currentIndex]),
//      body: appbarWidgets[_currentIndex],
//      bottomNavigationBar: bottomNavBar,
//    );
  }
}

class Db4BottomBar extends StatefulWidget {
  static String tag = '/T5BottomBar';

  Db4BottomBar({
    this.onTabSelected,
  });

  ValueChanged<int> onTabSelected;
  @override
  Db4BottomBarState createState() => Db4BottomBarState();
}

class Db4BottomBarState extends State<Db4BottomBar> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BubbleBottomBar(
      opacity: .2,
      currentIndex: currentIndex,
      elevation: 8,
      onTap: (index) {
        widget.onTabSelected(index);
        setState(() {
          currentIndex = index;
        });
      },
      hasNotch: false,
      hasInk: true,
      inkColor: COLOR_PRIMARY_LIGHT,
      items: <BubbleBottomBarItem>[
        tab("assets/ic_home.svg", "Dashboard"),
        tab("assets/ic_portfolio.svg", "Interest")
      ],
    );
  }

  BubbleBottomBarItem tab(String iconData, String tabName) {
    return BubbleBottomBarItem(
        backgroundColor: COLOR_PRIMARY,
        icon: SvgPicture.asset(
          iconData,
          height: 24,
          width: 24,
          color: COLOR_TEXT_PRIMARY,
        ),
        activeIcon: SvgPicture.asset(
          iconData,
          height: 24,
          width: 24,

          color: COLOR_PRIMARY,
        ),
        title: AutoSizeText(
          tabName,
          style: TextStyle(
              fontSize: textSizeMedium,
              fontFamily: fontMedium,
              color: COLOR_PRIMARY),
          maxLines: 1,
        ));
  }
}
