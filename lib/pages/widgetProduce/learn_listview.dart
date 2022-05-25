import 'package:flutter/material.dart';

class LearListView extends StatefulWidget {
  const LearListView({ Key? key }) : super(key: key);

  @override
  State<LearListView> createState() => _LearListViewState();
}

class _LearListViewState extends State<LearListView> {
  @override
  String loadingTag = "##loading##"; // 表尾标记
  var _words = ["##loading##"];
  Widget baseUseListView() {
    return ListView.builder(
      // itemCount: 20,
      itemExtent: 50.0,
      itemBuilder: (BuildContext context, int idx) {
        return ListTile(title: Text("$idx"),);
      });
  }

  Widget separatedListView() {
    Widget divider1 = Divider(color: Colors.amber,);
    Widget divider2 = Divider(color: Colors.brown,);
    return ListView.separated(
      itemCount: 30,
      itemBuilder: (BuildContext context, int idx) {
        return ListTile(title: Text("$idx"),);
      }, 
      separatorBuilder: (BuildContext context, int idx) {
        return idx % 2 == 1 ? divider1 : divider2;
      }
    );
  }

  Widget infiniteListView() =>  StatefulBuilder(
    builder: (BuildContext infiniteListViewContext, StateSetter infiniteListViewSetter) {
      
      

      void _retrieveData() {
        print('gggg');
        Future.delayed(Duration(seconds: 2)).then((value) {
          infiniteListViewSetter(() {
            // 重新构建列表
            _words.insertAll(
              _words.length - 1, 
              // 每次生成20个单词
              '123456'.split('')
            ); 
          });
        });
      }

      return ListView.separated(
        itemCount: _words.length,
        itemBuilder: (BuildContext infiniteListViewContext, int idx) {
            // 如果到了末尾
            if (_words[idx] == loadingTag) {
              // 不够100条，继续获取数据
              if (_words.length - 1 < 20) {
                // 获取数据
                _retrieveData();
                // 加载时显示loading
                return Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0)
                  ),
                );
              } else {
                // 已经加载了100条数据，不再获取数据
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text("没有更多了", style: TextStyle(color: Colors.grey),),
                );
              }
            }
            // 显示单词列表项
            return ListTile(title: Text(_words[idx]));
        },
        separatorBuilder: (BuildContext infiniteListViewContext, int idx) => const Divider(height: .0,), 
      );
    });

  Widget build(BuildContext context) {
    return Scaffold(
      body: infiniteListView(),
    );
  }
}