import 'package:flutter/material.dart';
import 'dart:math' as math;

class LearnTransform extends StatefulWidget {
  const LearnTransform({ Key? key }) : super(key: key);

  @override
  State<LearnTransform> createState() => _LearnTransformState();
}

/// 注意：
/// Transform的变换是应用在绘制阶段，而并不是应用在布局(layout)阶段，
/// 所以无论对子组件应用何种变化，其占用空间的大小和在屏幕上的位置都是固定不变的，因为这些是在布局阶段就确定的。
class _LearnTransformState extends State<LearnTransform> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: Column(children: [
        Align(child: Text('原始状态'),),
        DecoratedBox(
          decoration: BoxDecoration(color: Colors.blue[400]),
          child: Text('Hello World')
        ),
        Align(child: Text('平移状态'),),
        DecoratedBox(
          decoration: BoxDecoration(color: Colors.blue[400]),
          //默认原点为左上角，左移20像素，向上平移5像素  
          child: Transform.translate(
            offset: Offset(-20.0, -5.0),
            child: Text('Hello World'),
          ),
        ),
        Align(child: Text('旋转状态'),),
        DecoratedBox(decoration: BoxDecoration(color: Colors.blue[400]),
          child: Transform.rotate(
            // 旋转90度
            angle: math.pi/2,
            child: Text('Hello World'),
          ),
        ),
        Align(child: Text('缩放状态'),),
        DecoratedBox(decoration: BoxDecoration(color: Colors.blue[400]),
          child: Transform.scale(
            scale: 2,
            child: Text('Hello World'),
          ),
        )
      ],)
    ),
    );
  }
}