// ignore_for_file: file_names

import 'package:flutter/material.dart';


class AnimatedImage extends AnimatedWidget {
  AnimatedImage({Key? key,required Animation<double> animation})
  : super(key: key, listenable: animation);

  @override 
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Image.asset(
        'img/diamond.png',
        width: animation.value,
        height: animation.value,
      ),
    );
  }
}

class LearnAnima extends StatefulWidget {
  const LearnAnima({ Key? key }) : super(key: key);

  @override
  State<LearnAnima> createState() => _LearnAnimaState();
}
// 需要继承TickerProvider，如果有多个AnimationController，则应该使用TickerProviderStateMixin。
class _LearnAnimaState extends State<LearnAnima>
  with SingleTickerProviderStateMixin {

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // 通常我们会将SingleTickerProviderStateMixin添加到State的定义中，然后将State对象作为vsync的值
    // 默认匀速
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2)
    );

    // 弹性曲线
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    final use = false ? controller : animation;
    // 图片宽高从0到300
    animation = Tween(begin: 0.0, end: 300.0).animate(use)
      ..addListener(() {
        setState(() {
          
        });
      });
    
    // 监听动画状态
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 动画结束后反向执行
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // 动画恢复到初始状态时执行正向动画
        controller.forward();
      }
    });
    
    // 启动动画，正向执行
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 普通使用
    // return Center(
    //   child: Image.asset(
    //     'img/diamond.png',
    //     width: animation.value,
    //     height: animation.value,
    //   ),
    // );

    // 提取使用
    // return AnimatedImage(animation: animation);

    // 渲染逻辑分离
    // 三个好处：
    // 不用显式的去添加帧监听器，然后再调用setState() 了，这个好处和AnimatedWidget是一样的。
    // 更好的性能：因为动画每一帧需要构建的 widget 的范围缩小了，如果没有builder，setState()将会在父组件上下文中调用，这将会导致父组件的build方法重新调用；而有了builder之后，只会导致动画widget自身的build重新调用，避免不必要的rebuild。
    // 通过AnimatedBuilder可以封装常见的过渡效果来复用动画。
    // return AnimatedBuilder(
    //   animation: animation, 
    //   child: Image.asset('img/diamond.png'),
    //   builder: (BuildContext ctx, child) {
    //     return Center(
    //       child: SizedBox(
    //         height: animation.value,
    //         width: animation.value,
    //         child: child,
    //       ),
    //     );
    //   });

    // 封装一个过渡效果
    return GrowTransition(
      animation: animation,
      child: Image.asset('img/diamond.png')
    );
  }
}

class GrowTransition extends StatelessWidget {
  final Widget? child;
  final Animation<double> animation;
  const GrowTransition({ Key? key, required this.animation, this.child }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          return SizedBox(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
      ),
    );
  }
}