import 'package:flutter/material.dart';

class LearnCustomerScrollView extends StatefulWidget {
  const LearnCustomerScrollView({ Key? key }) : super(key: key);

  @override
  State<LearnCustomerScrollView> createState() => _LearnCustomerScrollViewState();
}

class _LearnCustomerScrollViewState extends State<LearnCustomerScrollView> {
  // 实现功能： 我们想将已有的两个沿垂直方向滚动的 ListView 成一个 ListView ，这样在第一ListView 滑动到底部时能自动接上第二 ListView
  // 我们自己创建一个共用的 Scrollable 和 Viewport 对象，然后再将两个 ListView 对应的 Sliver 添加到这个共用的 Viewport 对象中就可以实现我们想要的效果了。如果这个工作让开发者自己来做无疑是比较麻烦的，因此 Flutter 提供了一个 CustomScrollView 组件来帮助我们创建一个公共的 Scrollable 和 Viewport ，
  // 然后它的 slivers 参数接受一个 Sliver 数组，这样我们就可以使用CustomScrollView 方面的实现我们期望的功能了

  normalUseCustomScrollView() {
    // SliverFixedExtentList 是一个 Sliver，它可以生成高度相同的列表项。
    // 再次提醒，如果列表项高度相同，我们应该优先使用SliverFixedExtentList 
    // 和 SliverPrototypeExtentList，如果不同，使用 SliverList.
    // 这样可以使不同的view整合在一起，使用同一个滚动
    var listview = SliverFixedExtentList(
      delegate: SliverChildBuilderDelegate(
        (_, idx) => ListTile(title: Text('$idx'),),
        childCount: 10
      ), itemExtent: 56);
    return CustomScrollView(
      slivers: [
        listview,
        listview
      ],
    );
  }

  customerSliverUse() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: normalUseCustomScrollView(),
    );
  }
}