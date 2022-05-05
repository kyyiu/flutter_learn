import 'package:flutter/material.dart';

class LearnClip extends StatelessWidget {
  const LearnClip({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatar = Image.asset('img/diamond.png', width: 60.0,);
    return Center(
      child: Column(
        children: [
          avatar,//不裁剪
          ClipOval(child: avatar,), // 裁剪为圆形
          ClipRRect(
            // 裁剪为圆角矩形
            child: avatar,
            borderRadius: BorderRadius.circular(5.0)
          ),

          // 通过Align设置widthFactor为0.5后，
          // 图片的实际宽度等于60×0.5，即原宽度一半，
          // 但此时图片溢出部分依然会显示，所以第一个“你好世界”会和图片的另一部分重合，
          // 为了剪裁掉溢出部分，我们在第二个Row中通过ClipRect将溢出部分剪裁掉了

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                widthFactor: .5, // 宽度设置为原来宽度的一半, 另一半会溢出
                child: avatar,
              ),
              Text('Hello World', style: TextStyle(color: Colors.green),)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRect( // 将溢出部分裁剪
                child: Align(
                  alignment: Alignment.topLeft,
                  widthFactor: .5, // 宽度设为原来的一半
                  child: avatar,
                ),
              ),
              Text('Hello World', style: TextStyle(color: Colors.green),)
            ],
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.amber
            ),
            child: ClipRect(
              clipper: MyClipper(), // 使用自定义clipper
              child: avatar,
            ),
          )
        ],
      ),
    );
  }
}


// 自定义裁剪特定区域
// 接口决定是否重新剪裁。如果在应用中，
// 剪裁区域始终不会发生变化时应该返回false，
// 这样就不会触发重新剪裁，避免不必要的性能开销。
// 如果剪裁区域会发生变化（比如在对剪裁区域执行一个动画），
// 那么变化后应该返回true来重新执行剪裁。
class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(10.0, 15.0, 40.0, 30.0);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}