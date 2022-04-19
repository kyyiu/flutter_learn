
import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/widgetProduce/learnCheckBox.dart';
import 'package:flutter_application_1/pages/widgetProduce/learnWidget.dart';

import 'pages/widgetProduce/learnButton.dart';


class MyRoute {
  static Map<String, Function> routes = {
    '/': (context, {arguments}) => MyHomePage(title: 'aa'),
    '/lifeCircle': (context, {arguments}) => LearnWidgetful(initValue: arguments["initVal"],),
    '/button': (context, {arguments}) => LearnButton(),
    '/checkBox': (context, {arguments}) => LearnCheckBox()
  };

  static List<String> routeName = [
    '/',
    '/lifeCircle',
    '/button',
    '/checkBox'
  ];

  static List<String> chineseRouteName = [
    '首页（点击无事发生）',
    'widget学习-state生命周期',
    '按钮',
    '开关和复选框'
  ];
} 


/**
这个方法在打开命名路由时可能会被调用，
之所以说可能，是因为当调用Navigator.pushNamed(...)打开命名路由时，
如果指定的路由名在路由表中已注册，则会调用路由表中的builder函数来生成路由组件；
如果路由表中没有注册，才会调用onGenerateRoute来生成路由。
 */
Route onGenerateRoute(RouteSettings settings) {
  final String? name = settings.name;
  final Function?  pageContentBuilder = MyRoute.routes[name];
  if (pageContentBuilder != null) {
    final Route route = MaterialPageRoute(
      settings: RouteSettings(name: name),
      builder: (context) => pageContentBuilder(context, arguments: settings.arguments));
    return route;
  }
  final Route route = MaterialPageRoute(builder: (context)=>pageContentBuilder!(context));
  return route;
}