import 'package:flutter/material.dart';

class LearnFittedBox extends StatelessWidget {
  const LearnFittedBox({ Key? key }) : super(key: key);

  Widget wContainer(BoxFit boxFit) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.red,
      child: FittedBox(
        fit: boxFit, // 子容器超过父容器大小
        child: Container(width: 60 , height: 70, color: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        wContainer(BoxFit.none),
        Text('Wendux'),
        wContainer(BoxFit.contain),
        Text('China')
      ],),
    );
  }
}