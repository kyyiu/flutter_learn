import 'package:flutter/material.dart';

class LearnFutureBuilder extends StatefulWidget {
  const LearnFutureBuilder({ Key? key }) : super(key: key);

  @override
  State<LearnFutureBuilder> createState() => _LearnFutureBuilderState();
}

class _LearnFutureBuilderState extends State<LearnFutureBuilder> {


  normalUseFutureBuilder() {
    Future<String> mockNetWorkData() async {
      return Future.delayed(Duration(seconds: 2), () =>  "得到请求数据");
    }

    // 每次组件重新build 都会重新发起请求，因为每次的 future 都是新的，
    // 实践中我们通常会有一些缓存策略，
    // 常见的处理方式是在 future 成功后将 future 缓存，这样下次build时，就不会再重新发起异步任务。
    return FutureBuilder(
      future: mockNetWorkData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     enum ConnectionState {
        //     当前没有异步任务，比如[FutureBuilder]的[future]为null时
        //     none,
        //     /// 异步任务处于等待状态
        //     waiting,
        //     /// Stream处于激活状态（流上已经有数据传递了），对于FutureBuilder没有该状态。
        //     active,
        //     /// 异步任务已经终止.
        //     done,
        //   }
        //   注意，ConnectionState.active只在StreamBuilder中才会出现。
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('ERR: --${snapshot.error}');
          }
          return Text('内容是--${snapshot.data}');
        }
        return const CircularProgressIndicator();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: normalUseFutureBuilder(),
    );
  }
}