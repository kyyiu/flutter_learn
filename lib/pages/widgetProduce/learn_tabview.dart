import 'package:flutter/material.dart';

class LearnTabView extends StatefulWidget {
  const LearnTabView({ Key? key }) : super(key: key);

  @override
  State<LearnTabView> createState() => _LearnTabViewState();
}

class _LearnTabViewState extends State<LearnTabView> {
  // TabController 用于监听和控制 TabBarView 的页面切换，通常和 TabBar 联动。如果没有指定，则会在组件树中向上查找并使用最近的一个 DefaultTabController

  normalUse() {
    List tabs = ['tab1', 'tab2', 'tab3'];
    return Builder(builder: (BuildContext context) {
      return DefaultTabController(
        length: tabs.length, 
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
                title: Text('app'),
                bottom: TabBar(
                  tabs: tabs.map((e) => Tab(text: '$e--')).toList()
                ),
            ),
            body: TabBarView(
              // 如果需要缓存，参考learn_pageview文件
              children: tabs.map((e) {
                return GestureDetector(
                  onTap: () {
                    print(DefaultTabController.of(context)!.index);
                  },
                  child: Container(child: Text(e),)
                );
              }).toList(),
            ),
          );
        })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return normalUse();
  }
}