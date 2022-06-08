import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LearnListener extends StatefulWidget {
  const LearnListener({Key? key}) : super(key: key);

  @override
  State<LearnListener> createState() => _LearnListenerState();
}

class _LearnListenerState extends State<LearnListener> {
  PointerEvent? _event;
  double _top = 100.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移
  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  bool _toggle = false; //变色开关

  String _msg="";

  @override
  void dispose() {
    super.dispose();
    // 使用GestureRecognizer后一定要调用其dispose()方法来释放资源（主要是取消内部的计时器）。
    _tapGestureRecognizer.dispose();
  }

  normalUse() {
    bindEvent(PointerEvent e) {
      setState(() {
        _event = e;
      });
    }

    return Listener(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue[300],
        child: Text(
          '${_event?.localPosition ?? ""}',
          style: const TextStyle(color: Colors.white),
        ),
        // position：它是指针相对于当对于全局坐标的偏移。
        // localPosition: 它是指针相对于当对于本身布局坐标的偏移。
        // delta：两次指针移动事件（PointerMoveEvent）的距离。
        // pressure：按压力度，如果手机屏幕支持压力传感器(如iPhone的3D Touch)，此属性会更有意义，如果手机不支持，则始终为1。
        // orientation：指针移动方向，是一个角度值。
      ),
      onPointerDown: (PointerEvent e) => bindEvent(e),
      onPointerMove: (PointerEvent e) => bindEvent(e),
      onPointerUp: (PointerEvent e) => bindEvent(e),
    );
  }

  ignoreEventUse() {
    // 假如我们不想让某个子树响应PointerEvent的话，
    // 我们可以使用IgnorePointer和AbsorbPointer，这两个组件都能阻止子树接收指针事件，
    // 不同之处在于AbsorbPointer本身会参与命中测试，而IgnorePointer本身不会参与，
    // 这就意味着AbsorbPointer本身是可以接收指针事件的(但其子树不行)，而IgnorePointer不可以。
    return Listener(
        child: AbsorbPointer(
          child: Listener(
            child: Container(
              color: Colors.pink,
            ),
            onPointerDown: (event) => print('inner down'),
          ),
        ),
        onPointerDown: (event) => print('out down'));
  }

  dragEventUse() {
    // GestureDetector会将要监听的组件的原点（左上角）作为本次手势的原点，当用户在监听的组件上按下手指时，手势识别就会开始
    return Container(
      color: Colors.amber,
      child: Stack(
        children: [
          Positioned(
              top: _top,
              left: _left,
              child: GestureDetector(
                child: CircleAvatar(
                  child: Text('A'),
                ),
                // 手指按下触发
                onPanDown: (DragDownDetails e) {
                  // 打印手指按下的位置（相对于屏幕)
                  print('aaa--${e.globalPosition}');
                },
                // 手指滑动触发
                onPanUpdate: (DragUpdateDetails e) {
                  setState(() {
                    _top += e.delta.dy;
                    _left += e.delta.dx;
                  });
                },
                onPanEnd: (DragEndDetails e) {
                  // 打印滑动结束时在x、y轴上的速度
                  print('${e.velocity}');
                },
              ))
        ],
      ),
    );
  }

  normalTapRecognizerUse() {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'hello'),
            TextSpan(
              recognizer: _tapGestureRecognizer
                ..onTap = () {
                  setState(() {
                    _toggle = !_toggle;
                  });
                },
              text: '点我变色', style: TextStyle(fontSize: 30.0, color: _toggle ? Colors.lightBlueAccent : Colors.purple)),
            TextSpan(
              text: 'world'
            )
          ]
        )
      ),
    );
  }

  notificationUse() {
    // 监听通知
    return NotificationListener<MyNotification>(
      onNotification: (notification) {
        setState(() {
          _msg += notification.msg + "  ";
        });
        return true;
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(builder: (context) {
              return ElevatedButton(onPressed: () => MyNotification('hello').dispatch(context), child: Text('send msg'));
            }),
            Text(_msg)
          ],
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return notificationUse();
  }
}

class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
}