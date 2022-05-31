import 'package:flutter/material.dart';

class LearnScrollController extends StatefulWidget {
  const LearnScrollController({Key? key}) : super(key: key);

  @override
  State<LearnScrollController> createState() => _LearnScrollControllerState();
}

class _LearnScrollControllerState extends State<LearnScrollController> {
  // 我们创建一个ListView，当滚动位置发生变化时，我们先打印出当前滚动位置，然后判断当前位置是否超过1000像素，
  // 如果超过则在屏幕右下角显示一个“返回顶部”的按钮，该按钮点击后可以使ListView恢复到初始位置；如果没有超过1000像素，则隐藏“返回顶部”按钮。

  ScrollController _controller_scroll = ScrollController();
  bool _showToTopBtn = false;
  String _progress = "0%";

  List<String> data = [];
  int count = 5;
  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < count; i++) {
      data.add('${i + 1}');
    }

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

  buildNormalScroll() {
    return Scrollbar(
      child: ListView.builder(
          itemCount: 100,
          itemExtent: 50.0,
          controller: _controller_scroll,
          itemBuilder: (BuildContext context, int idx) {
            return ListTile(
              title: Text('$idx'),
            );
          }),
    );
  }

  buildScrollNotification() {
    return Scrollbar(
        // 进度条
        // 监听滚动通知
        child: NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        double progress =
            notification.metrics.pixels / notification.metrics.maxScrollExtent;

        // pixels：当前滚动位置。
        // maxScrollExtent：最大可滚动长度。
        // extentBefore：滑出ViewPort顶部的长度；此示例中相当于顶部滑出屏幕上方的列表长度。
        // extentInside：ViewPort内部长度；此示例中屏幕显示的列表部分的长度。
        // extentAfter：列表中未滑入ViewPort部分的长度；此示例中列表底部未显示到屏幕范围部分的长度。
        // atEdge：是否滑到了可滚动组件的边界（此示例中相当于列表顶或底部）
        // 重新构建
        setState(() {
          _progress = "${(progress * 100).toInt()}%";
        });
        return true; // 代表是否阻止该事件继续向上冒泡，如果为true时，则冒泡终止，事件停止向上传播，如果不返回或者返回值为false 时，则冒泡继续。
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ListView.builder(
              itemCount: 100,
              itemExtent: 50.0,
              itemBuilder: (BuildContext ctx, int idx) => ListTile(
                    title: Text('$idx'),
                  )),
          CircleAvatar(
            // 显示进度百分比
            radius: 30.0,
            child: Text(_progress),
            backgroundColor: Colors.black54,
          )
        ],
      ),
    ));
  }

  // AnimatedList 可以在列表中插入或删除节点时执行一个动画，在需要添加或删除列表项的场景中会提高用户体验。
  buildAnimatedList() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setter) {
      buildAnimatedListAddBtn() {
        return Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // 添加一个列表项
                data.add('${++count}');
                // 告诉列表有新添加项
                globalKey.currentState!.insertItem(data.length - 1);
              },
            ));
      }

      buildAnimatedListItem(BuildContext ctx, int idx) {
        String char = data[idx];

        void del(BuildContext context, int index) {
          // 删除的时候需要我们通过AnimatedListState 的 removeItem 方法来应用删除动画
          setter(() {
            globalKey.currentState!.removeItem(index, (context, animation) {
              // 删除过程执行的是反向动画，animation.value 会从1变为0
              var item = buildAnimatedListItem(context, index);
              data.removeAt(index);
              // 删除动画是一个合成动画：渐隐 + 缩小列表项告诉
              return FadeTransition(
                opacity: CurvedAnimation(
                    parent: animation,
                    // 让透明变换快点
                    curve: const Interval(0.5, 1.0)),
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: 0.0,
                  child: item,
                ),
              );
            }, duration: const Duration(milliseconds: 200));
          });
        }

        return ListTile(
          key: ValueKey(char),
          title: Text(char),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => del(ctx, idx),
          ),
        );
      }

      return Stack(
        children: [
          AnimatedList(
              key: globalKey,
              initialItemCount: data.length,
              itemBuilder:
                  (BuildContext context, int idx, Animation<double> animation) {
                // 添加时展现 渐显动画
                return FadeTransition(
                  opacity: animation,
                  child: buildAnimatedListItem(context, idx),
                );
              }),
          buildAnimatedListAddBtn()
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('滚动和回到顶部'),
      ),
      body: buildAnimatedList(),
      floatingActionButton: _showToTopBtn
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                _controller_scroll.animateTo(.0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              })
          : null,
    );
  }
}
