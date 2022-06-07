import 'package:flutter/material.dart';

/// 作用
// 如果要实现页面切换和 Tab 布局，我们可以使用 PageView 组件。需要注意，PageView 是一个非常重要的组件，
// 因为在移动端开发中很常用，比如大多数 App 都包含 Tab 换页效果、图片轮动以及抖音上下滑页切换视频功能等等，这些都可以通过 PageView 轻松实现。


class KeepAlivePageView extends StatefulWidget {
  final String txt;
  const KeepAlivePageView(this.txt, { Key? key }) : super(key: key);

  @override
  State<KeepAlivePageView> createState() => _KeepAlivePageViewState();
}

class _KeepAlivePageViewState extends State<KeepAlivePageView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    // 此时就只会构建一次,然后缓存起来了
    print('build keep alive ${widget.txt}');
    return Center(child: Text(widget.txt),);
  }

  @override 
  bool get wantKeepAlive => true; // 是否需要缓存
}

class LearnPageView extends StatefulWidget {
  const LearnPageView({ Key? key }) : super(key: key);

  @override
  State<LearnPageView> createState() => _LearnPageViewState();
}

class _LearnPageViewState extends State<LearnPageView> {

  createItem(String txt) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setter) {
      // 每当页面切换时都会触发新 Page 页的 build，比如我们从第一页滑到第二页，然后再滑回第一页时
      // PageView 默认并没有缓存功能，一旦页面滑出屏幕它就会被销毁
      print('bbbbuild $txt');
      return Center(
        child: Text(txt, textScaleFactor: 5,),
      );
    });
  }

  // 可滚动组件子项缓存
  // 让Page 页变成一个 AutomaticKeepAlive Client 即可。
  // 为了便于开发者实现，Flutter 提供了一个 AutomaticKeepAliveClientMixin ，
  // 我们只需要让 PageState 混入这个 mixin，且同时添加一些必要操作即可：
  keepAlivePageView() {
    List<KeepAlivePageView> children = [];
    for(int i = 0; i < 6; i++) {
      children.add(KeepAlivePageView('$i--'));
    }
    return PageView(
      // scrollDirection: Axis.vertical, // 垂直滚动
      children: children,
    );
  }


  normalUse() {
    List<Widget> children = [];
    for(int i = 0; i < 6; i++) {
      children.add(createItem('$i'));
    }
    return PageView(
      // scrollDirection: Axis.vertical, // 垂直滚动
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return keepAlivePageView();
  }
}