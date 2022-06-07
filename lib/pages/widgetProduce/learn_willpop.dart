import 'package:flutter/material.dart';

class LearnWillPop extends StatefulWidget {
  const LearnWillPop({ Key? key }) : super(key: key);

  @override
  State<LearnWillPop> createState() => _LearnWillPopState();
}

class _LearnWillPopState extends State<LearnWillPop> {
  DateTime? lastBackTime;

  /// 实现功能
  /// 为了避免用户误触返回按钮而导致 App 退出，在很多 App 中都拦截了用户点击返回键的按钮，然后进行一些防误触判断，
  /// 比如当用户在某一个时间段内点击两次时，才会认为用户是要退出（而非误触）。Flutter中可以通过WillPopScope来实现返回按钮拦截
  normalUse() {
    return StatefulBuilder(builder:  (BuildContext context, StateSetter setter) {
      return WillPopScope(
        child: Container(child: Text('连点两次返回，才能返回')), 
        onWillPop: () async {
          if (lastBackTime == null || DateTime.now().difference(lastBackTime!) > Duration(seconds: 1)) {
            lastBackTime = DateTime.now();
            return false;
          }
          return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return normalUse();
  }
}