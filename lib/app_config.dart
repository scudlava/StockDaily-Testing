import 'package:flutter/material.dart';
import 'package:myfinancial/constant/string.dart';

class ApplicationConfig extends InheritedWidget{

  ApplicationConfig({this.appDisplayName=str_app_name, this.isDev=false, Widget child})
      : super(child: child);

  final String appDisplayName;
  final bool isDev;

  static ApplicationConfig of(BuildContext context) {
//    return context.inheritFromWidgetOfExactType(ApplicationConfig);
    return context.dependOnInheritedWidgetOfExactType<ApplicationConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}