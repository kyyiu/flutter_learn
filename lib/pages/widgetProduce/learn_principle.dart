import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Learn_Principle extends StatefulWidget {
  const Learn_Principle({Key? key}) : super(key: key);

  @override
  State<Learn_Principle> createState() => _Learn_PrincipleState();
}

class _Learn_PrincipleState extends State<Learn_Principle> {
  ByteData? byteData;
  useSelfComponent() {
    return SelfComponentWidget();
  }

  useLayer() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChessWidget(),
          ElevatedButton(
            onPressed: () {
              setState(() => {});
            },
            child: Text("setState"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: useLayer(),
    );
  }
}

class LearnStateLess extends StatelessWidget {
  const LearnStateLess({Key? key}) : super(key: key);

  // StatelessWidget是个抽象类

  // 实现抽象类中的build方法,传入LearnStateLess实例到StatelessElement中通过widget.build(this)调用,这里context即是this，而this正是StatelessElement实例, stateful同理
  // BuildContext就是widget对应的Element，
  // 所以我们可以通过context在StatelessWidget和StatefulWidget的build方法中直接访问Element对象。
  // 我们获取主题数据的代码Theme.of(context)内部正是调用了Element的dependOnInheritedWidgetOfExactType()方法。
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// 自定义实现StatelessWidget
class SelfComponentElement extends ComponentElement {
  SelfComponentElement(Widget w) : super(w);
  String txt = '123456789';

  @override
  Widget build() {
    // this即是elemnt实例本身
    Color primary = Theme.of(this).primaryColor;
    return GestureDetector(
      child: Center(
        child: ElevatedButton(
          child: Text(txt),
          onPressed: () {
            var t = txt.split('')..shuffle();
            txt = t.join('');
            markNeedsBuild(); //点击后将该Element标记为dirty，Element将会rebuild
          },
        ),
      ),
    );
  }
}

// 由于flutter设计上通过widget createlemt插入，所以需要实现一下适配
// 此时SelfComponentWidget 就可以像其他flutter一样使用了
class SelfComponentWidget extends Widget {
  @override
  Element createElement() {
    return SelfComponentElement(this);
  }
}

// 绘制原理
// Flutter中和绘制相关的对象有三个，分别是Canvas、Layer 和 Scene：

// Canvas：封装了Flutter Skia各种绘制指令，比如画线、画圆、画矩形等指令。
// Layer：分为容器类和绘制类两种；暂时可以理解为是绘制产物的载体，比如调用 Canvas 的绘制 API 后，相应的绘制产物被保存在 PictureLayer.picture 对象中。
// Scene：屏幕上将要要显示的元素。在上屏前，我们需要将Layer中保存的绘制产物关联到 Scene 上。
// Flutter 绘制流程：

// 构建一个 Canvas，用于绘制；同时还需要创建一个绘制指令记录器，因为绘制指令最终是要传递给 Skia 的，而 Canvas 可能会连续发起多条绘制指令，指令记录器用于收集 Canvas 在一段时间内所有的绘制指令，因此Canvas 构造函数第一个参数必须传递一个 PictureRecorder 实例。
// Canvas 绘制完成后，通过 PictureRecorder 获取绘制产物，然后将其保存在 Layer 中。
// 构建 Scene 对象，将 layer 的绘制产物和 Scene 关联起来。
// 上屏；调用window.render API 将Scene上的绘制产物发送给GPU。

/// 通过 Layer 实现绘制缓存
class ChessWidget extends LeafRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderChess();
  }
}

class RenderChess extends RenderBox {
  // 保存之前的棋盘大小
  Rect _rect = Rect.zero;
  // 定义一个新的 layerHandle
  final layerHandle = LayerHandle<PictureLayer>();

  @override
  void dispose() {
    //layer通过引用计数的方式来跟踪自身是否还被layerHandle持有，
    //如果不被持有则会释放资源，所以我们必须手动置空，该set操作会
    //解除layerHandle对layer的持有。
    layerHandle.layer = null;
    super.dispose();
  }

  
  @override
  void performLayout() {
    //确定ChessWidget的大小
    size = constraints.constrain(
      constraints.isTight ? Size.infinite : Size(150, 150),
    );
  }

  void drawChessboard(Canvas canvas, Rect rect) {
    //棋盘背景
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill //填充
      ..color = Color(0xFFDCC48C);
    canvas.drawRect(rect, paint);

    //画棋盘网格
    paint
      ..style = PaintingStyle.stroke //线
      ..color = Colors.black38
      ..strokeWidth = 1.0;

    //画横线
    for (int i = 0; i <= 15; ++i) {
      double dy = rect.top + rect.height / 15 * i;
      canvas.drawLine(Offset(rect.left, dy), Offset(rect.right, dy), paint);
    }

    for (int i = 0; i <= 15; ++i) {
      double dx = rect.left + rect.width / 15 * i;
      canvas.drawLine(Offset(dx, rect.top), Offset(dx, rect.bottom), paint);
    }
  }

//画棋子
  void drawPieces(Canvas canvas, Rect rect) {
    double eWidth = rect.width / 15;
    double eHeight = rect.height / 15;
    //画一个黑子
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    //画一个黑子
    canvas.drawCircle(
      Offset(rect.center.dx - eWidth / 2, rect.center.dy - eHeight / 2),
      min(eWidth / 2, eHeight / 2) - 2,
      paint,
    );
    //画一个白子
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(rect.center.dx + eWidth / 2, rect.center.dy - eHeight / 2),
      min(eWidth / 2, eHeight / 2) - 2,
      paint,
    );
  }

  // _checkIfChessboardNeedsUpdate(Rect rect) {
  //   // 如果绘制区域大小没发生变化，则无需重绘棋盘
  //   if (_rect == rect) return;

  //   // 绘制区域发生了变化，需要重新绘制并缓存棋盘
  //   _rect = rect;
  //   print("paint chessboard");
  //   // 新建一个PictureLayer，用于缓存棋盘的绘制结果，并添加到layer中
  //   PictureRecorder recorder = PictureRecorder();
  //   Canvas canvas = Canvas(recorder);
  //   drawChessboard(canvas, rect); //绘制棋盘
  //   // 将绘制产物保存在pictureLayer中
  //   _layer = PictureLayer(Rect.zero)..picture = recorder.endRecording();
  //   print('ttt');
  //   print(_layer);
  // }

  // @override
  // void paint(PaintingContext context, Offset offset) {
  //   Rect rect = offset & size;
  //   //检查棋盘大小是否需要变化，如果变化，则需要重新绘制棋盘并缓存
  //   _checkIfChessboardNeedsUpdate(rect);
  //   //将缓存棋盘的layer添加到context中，每次重绘都要调用，原因下面会解释
  //   // 因为重绘是当前节点的第一个父级向下发起的，而每次重绘前，该节点都会先清空所有的孩子，
  //   // 代码见 PaintingContext.repaintCompositedChild 方法，所以我们需要每次重绘时都要添加一下。
  //   context.addLayer(_layer);
  //   //再画棋子
  //   print("paint pieces");
  //   drawPieces(context.canvas, rect);
  // }

_checkIfChessboardNeedsUpdate(Rect rect) {
  // 如果绘制区域大小没发生变化，则无需重绘棋盘
  if (_rect == rect) return;
  
  // 绘制区域发生了变化，需要重新绘制并缓存棋盘
  _rect = rect;
  print("paint chessboard");
 
  // 新建一个PictureLayer，用于缓存棋盘的绘制结果，并添加到layer中
  PictureRecorder recorder = PictureRecorder();
  Canvas canvas = Canvas(recorder);
  drawChessboard(canvas, rect); //绘制棋盘
  // 将绘制产物保存在pictureLayer中
  layerHandle.layer = PictureLayer(Rect.zero)..picture = recorder.endRecording();
}

@override
void paint(PaintingContext context, Offset offset) {
  Rect rect = offset & size;
  //检查棋盘大小是否需要变化，如果变化，则需要重新绘制棋盘并缓存
  _checkIfChessboardNeedsUpdate(rect);
  //将缓存棋盘的layer添加到context中，每次重绘都要调用，原因下面会解释
  //将缓存棋盘的layer添加到context中
  context.addLayer(layerHandle.layer!);
  //再画棋子
  print("paint pieces");
  drawPieces(context.canvas, rect);
}
}
