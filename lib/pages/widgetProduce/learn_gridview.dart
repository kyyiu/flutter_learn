import 'package:flutter/material.dart';

class LearnGrid extends StatefulWidget {
  const LearnGrid({ Key? key }) : super(key: key);

  @override
  State<LearnGrid> createState() => _LearnGridState();
}

class _LearnGridState extends State<LearnGrid> {

  List<IconData> icons = []; //保存Icon数据

  @override
  void initState() {
    super.initState();
  }

  //模拟异步获取数据
  void _retrieveIcons(StateSetter setter) {
    Future.delayed(Duration(milliseconds: 4000)).then((e) {
      setter(() {
        icons.addAll([
          Icons.ac_unit,
          Icons.airport_shuttle,
          Icons.all_inclusive,
          Icons.beach_access,
          Icons.cake,
          Icons.free_breakfast,
        ]);
      });
    });
  }


  // Flutter中提供了两个SliverGridDelegate的子类SliverGridDelegateWithFixedCrossAxisCount和SliverGridDelegateWithMaxCrossAxisExtent
  sliverGridDelegateWithFixedCrossAxisCountUse() {
    // SliverGridDelegateWithFixedCrossAxisCount 该子类实现了一个横轴为固定数量子元素的layout算法

    // crossAxisCount：横轴子元素的数量。此属性值确定后子元素在横轴的长度就确定了，即ViewPort横轴长度除以crossAxisCount的商。
    // mainAxisSpacing：主轴方向的间距。
    // crossAxisSpacing：横轴方向子元素的间距。
    // childAspectRatio：子元素在横轴长度和主轴长度的比例。由于crossAxisCount指定后，子元素横轴长度就确定了，然后通过此参数值就可以确定子元素在主轴的长度。
    // 可以发现，子元素的大小是通过crossAxisCount和childAspectRatio两个参数共同决定的。注意，这里的子元素指的是子组件的最大显示空间，注意确保子组件的实际大小不要超出子元素的空间。
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 横轴3个widget
        childAspectRatio: 1.0 // 宽高比为1 (宽/高 = 1)
      ),
      children: [
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
      ],
    );

    // 快速构建
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access),
        Icon(Icons.cake),
        Icon(Icons.free_breakfast),
      ],
    );
  }


  sliverGridDelegateWithMaxCrossAxisExtentUse() {
    // SliverGridDelegateWithMaxCrossAxisExtent  该子类实现了一个横轴子元素为固定最大长度的layout算法

    // maxCrossAxisExtent为子元素在横轴上的最大长度，之所以是“最大”长度，是因为横轴方向每个子元素的长度仍然是等分的，
    // 举个例子，如果ViewPort的横轴长度是450，那么当maxCrossAxisExtent的值在区间[450/4，450/3)内的话，
    // 子元素最终实际长度都为112.5，而childAspectRatio所指的子元素横轴和主轴的长度比为最终的长度比。
    // 其它参数和SliverGridDelegateWithFixedCrossAxisCount相同

    // 总结，按maxCrossAxisExtent放，如果空间还剩，但是不足以放下一个，会把放下的都缩小，再放一个， 这个就是等分和最大的由来

    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120.0,
        childAspectRatio: 1.0
      ),
      children: [
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
        Icon(Icons.ac_unit),
      ],
    );

    // 快速构建
    return GridView.extent(
      maxCrossAxisExtent: 120.0,
      childAspectRatio: 2.0,
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access),
        Icon(Icons.cake),
        Icon(Icons.free_breakfast),
      ],
    );
  }


  gridViewBuilder() {
    return StatefulBuilder(builder: (BuildContext ctx, StateSetter setter) {
      _retrieveIcons(setter);
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        childAspectRatio: 1.0, //显示区域宽高相等
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        //如果显示到最后一个并且Icon总数小于200时继续获取数据
        if (index == icons.length - 1 && icons.length < 200) {
          _retrieveIcons(setter);
        }
        return Icon(icons[index]);
      },
      );
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gridViewBuilder(),
    );
  }
}