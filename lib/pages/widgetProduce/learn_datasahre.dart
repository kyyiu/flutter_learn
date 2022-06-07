import 'package:flutter/material.dart';

class ShareDataWidget extends InheritedWidget {
  ShareDataWidget({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final int data; //需要在子树中共享的数据，保存点击次数

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ShareDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>(); 
    // 如果只想拿到数据，而不会在ShareDataWidget发生变化时调用__TestWidgetState的didChangeDependencies()方法
    // return context.getElementForInheritedWidgetOfExactType<ShareDataWidget>().widget;

    /// 这两个的区别就是前者会注册依赖关系
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget重新build
  @override
  bool updateShouldNotify(ShareDataWidget old) {
    return old.data != data;
  }
}

class _TestShareData extends StatefulWidget {
  const _TestShareData({ Key? key }) : super(key: key);

  @override
  State<_TestShareData> createState() => __TestShareDataState();
}

class __TestShareDataState extends State<_TestShareData> {


  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();
    //父或祖先widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用。
    //如果build中没有依赖InheritedWidget，则此回调不会被调用。
    // didChangeDependencies回调，它会在“依赖”发生变化时被Flutter 框架调用。
    // 而这个“依赖”指的就是子 widget 是否使用了父 widget 中InheritedWidget的数据！如果使用了，则代表子 widget 有依赖；如果没有使用则代表没有依赖。
    // 这种机制可以使子组件在所依赖的InheritedWidget变化时来更新自身

    // 没有使用ShareDataWidget的数据，那么didChangeDependencies()将不会被调用，因为它并没有依赖ShareDataWidget。
    print("Dependencies change");
  }

  @override
  Widget build(BuildContext context) {
    return Text(ShareDataWidget.of(context)!.data.toString());
  }
}

class LearnDataShare extends StatefulWidget {
  const LearnDataShare({ Key? key }) : super(key: key);

  @override
  State<LearnDataShare> createState() => _LearnDataShareState();
}

class _LearnDataShareState extends State<LearnDataShare> {

  int count = 0;

  normalUse() {
    return ShareDataWidget(data: count, child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: _TestShareData(),//子widget中依赖ShareDataWidget
            ),
            ElevatedButton(
              child: Text("Increment"),
              //每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新  
              onPressed: () => setState(() => ++count),
            )
          ],
        ),);
  }

  @override
  Widget build(BuildContext context) {
    return normalUse();
  }
}