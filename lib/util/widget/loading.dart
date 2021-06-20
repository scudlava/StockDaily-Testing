import 'package:flutter/material.dart';
import 'package:myfinancial/constant/colors.dart';

import 'custom_widget.dart';

class CommonLoading extends StatefulWidget {
  final String message;

  const CommonLoading({Key key, this.message=''}) : super(key: key);

  @override
  _CommonLoadingState createState() => _CommonLoadingState();
}

class _CommonLoadingState extends State<CommonLoading> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: CustomWidget.bgAuth(),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Text(
                'Loading',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: COLOR_GREY
                ),
              ),
//              new AnimatedBuilder(
//                animation: animationController,
//                child: new Container(
//                  height: 128.0,
//                  width: 128.0,
//                  child: new Image.asset('assets/ic_loading.png'),
//                ),
//                builder: (BuildContext context, Widget _widget) {
//                  return new Transform.rotate(
//                    angle: animationController.value * 20.3,//animationController.value * 6.3,
//                    child: _widget,
//                  );
//                },
//              ),
              Container(
                height: 128.0,
                width: 128.0,
                child: Image(image: new AssetImage("assets/ic_loading_anim.gif")),
              )
            ],
          ),
//          new CircularProgressIndicator(),
          new Padding(
            padding: EdgeInsets.all(24.0),
            child: new Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: COLOR_DARK_GREY,
                fontSize: 16,
                fontWeight: FontWeight.w800
              ),
            ),
          )
        ],
      ),
    );
  }
}
