import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/widgetProduce/learnAnima.dart';
import 'package:flutter_application_1/pages/widgetProduce/learnCheckBox.dart';
import 'package:flutter_application_1/pages/widgetProduce/learnForm.dart';
import 'package:flutter_application_1/pages/widgetProduce/learnWidget.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_clip.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_fitted_box.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_gridview.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_listview.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_pageview.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_scaffold.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_scroll_controler.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_tabview.dart';
import 'package:flutter_application_1/pages/widgetProduce/learn_transfrom.dart';

import 'pages/widgetProduce/learnButton.dart';


class MyRoute {
  // 路由表
  static Map<String, Function> routes = {
    '/': (context, {arguments}) => MyHomePage(title: 'aa'),
    '/lifeCircle': (context, {arguments}) => LearnWidgetful(initValue: arguments["initVal"],),
    '/button': (context, {arguments}) => LearnButton(),
    '/checkBox': (context, {arguments}) => LearnCheckBox(),
    '/form': (context, {arguments}) => LearnForm(),
    '/animation': (context, {arguments}) => LearnAnima(),
    '/transfrom': (context, {arguments}) => LearnTransform(),
    '/clip': (context, {arguments}) => LearnClip(),
    '/fittedBox': (context, {arguments}) => LearnFittedBox(),
    '/scaffold': (context, {arguments}) => LearnScaffold(),
    '/ListView_builder': (context, {arguments}) => LearListView(),
    '/scroll_controller': (context, {arguments}) => LearnScrollController(),
    '/grid': (context, {arguments}) => LearnGrid(),
    '/pageView': (context, {arguments}) => LearnPageView(),
    '/tabView': (context, {arguments}) => LearnTabView(),
  };
  // 路由名称
  static List<String> routeName = [
    '/',
    '/lifeCircle',
    '/button',
    '/checkBox',
    '/form',
    '/animation',
    '/transfrom',
    '/clip',
    '/fittedBox',
    '/scaffold',
    '/ListView_builder',
    '/scroll_controller',
    '/grid',
    '/pageView',
    '/tabView'
  ];
  // 展示的入口
  static List<String> chineseRouteName = [
    '首页（点击无事发生）',
    'widget学习-state生命周期',
    '按钮',
    '开关和复选框',
    '表单',
    '动画',
    '变换',
    '裁剪',
    'fittedBox',
    'scaffold',
    'ListView_builder',
    '滚动监听和控制',
    'grid布局',
    'pageView',
    'tabView'
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