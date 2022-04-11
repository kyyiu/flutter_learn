// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';

class LearnWidgetful extends StatefulWidget {
  final int initValue;
  const LearnWidgetful({ Key? key, this.initValue = 0 }) : super(key: key);

  @override
  State<LearnWidgetful> createState() => _LearnWidgetfulState();
}

class _LearnWidgetfulState extends State<LearnWidgetful> {

  int _counter = 0;

  @override
  void initState() {
    /*
     * 当 widget 第一次插入到 widget 树时会被调用，
     * 对于每一个State对象，Flutter 框架只会调用一次该回调
     */
    super.initState();
    _counter = widget.initValue;
    print('initState');
  }

  @override
  void didChangeDependencies() {
    // 当State对象的依赖发生变化时会被调用,主要是以下几种
    /**
     * 1.父级结构中的层级发生变化时
     * 2.父级结构中的任一节点的widget类型发生变化时
     * 3.父级的属性(非属性值)发生变化，如container的height从有这个属性变成没有这个属性
     */
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  @override
  void didUpdateWidget(LearnWidgetful oldWidget) {
    /**
     *  widget 重新构建时
     * ，Flutter 框架会调用widget.canUpdate来检测 widget 树中同一位置的新旧节点，
     * 然后决定是否需要更新，如果widget.canUpdate返回true则会调用此回调。
     * 在新旧 widget 的key和runtimeType同时相等时didUpdateWidget()就会被调用。
     */
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  @override
  void deactivate() {
    // 当 State 对象从树中被移除时，会调用此回调。
    super.deactivate();
    print('deactivate');
  }

  @override
  void dispose() {
    // 当 State 对象从树中被永久移除时调用；通常在此回调中释放资源。
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    /**
     * 主要是用于构建 widget 子树的，会在如下场景被调用：
      在调用initState()之后。
      在调用didUpdateWidget()之后。
      在调用setState()之后。
      在调用didChangeDependencies()之后。
      在State对象从树中一个位置移除后（会调用deactivate）又重新插入到树的其它位置之后。
    */
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: Text('state生命周期'),
      ),
      body: Column(
        children: [
          Text('当前counter$_counter')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => _counter++);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}