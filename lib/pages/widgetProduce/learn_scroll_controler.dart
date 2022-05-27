import 'package:flutter/material.dart';

class LearnScrollController extends StatefulWidget {
  const LearnScrollController({ Key? key }) : super(key: key);

  @override
  State<LearnScrollController> createState() => _LearnScrollControllerState();
}

class _LearnScrollControllerState extends State<LearnScrollController> {

  // 我们创建一个ListView，当滚动位置发生变化时，我们先打印出当前滚动位置，然后判断当前位置是否超过1000像素，
  // 如果超过则在屏幕右下角显示一个“返回顶部”的按钮，该按钮点击后可以使ListView恢复到初始位置；如果没有超过1000像素，则隐藏“返回顶部”按钮。

  ScrollController _controller_scroll = ScrollController();
  bool _showToTopBtn = false;

  @override
  void initState() {
    super.initState();

    _controller_scroll.addListener(() {
      if (_controller_scroll.offset < 1000 && _showToTopBtn) {
        setState(() {
          _showToTopBtn = false;
        });
      } else if (_controller_scroll.offset >= 1000 && !_showToTopBtn) {
        setState(() {
          _showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller_scroll.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('滚动和回到顶部'),),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: 100,
          itemExtent: 50.0,
          controller: _controller_scroll,
          itemBuilder: (BuildContext context, int idx){
            return ListTile(title: Text('$idx'),);
          }),
      ),
      floatingActionButton: _showToTopBtn ? 
      FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: () {
          _controller_scroll.animateTo(.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
        })
        : null,
    );
  }
}