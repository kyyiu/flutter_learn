import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class LearnRequest extends StatefulWidget {
  const LearnRequest({ Key? key }) : super(key: key);

  @override
  State<LearnRequest> createState() => _LearnRequestState();
}

class _LearnRequestState extends State<LearnRequest> {
  bool _loading = false;
  String _text = "";
  Dio dio = Dio(); // 详细使用参考官方文档

  normalUse() {

    request() async {
      setState(() {
        _loading = true;
        _text = '正在请求';
      });
      try {
        // 创建一个httpClient
        HttpClient httpClient = HttpClient();
        // 打开链接
        HttpClientRequest req = await httpClient.getUrl(Uri.parse("https://www.baidu.com"));
        //使用iPhone的UA
        req.headers.add(
          "user-agent",
          "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1",
        );
        //等待连接服务器（会将请求信息发送给服务器）
        HttpClientResponse response = await req.close();
        //读取响应内容
        _text = await response.transform(utf8.decoder).join().toString();
        //输出响应头
        print(response.headers);
        //关闭client后，通过该client发起的所有请求都会中止。
        httpClient.close();
      } catch (e) {
        _text = '请求失败 $e';
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }

    return SingleChildScrollView(
      child: Column(children: [
        ElevatedButton(onPressed: _loading ? null : request, child: Text('获取百度首页')),
        Container(
          width: MediaQuery.of(context).size.width - 50.0,
          child: Text(_text.replaceAll(RegExp(r'\s'), '')),
        )
      ],),
    );
  }


  dioUse() {
    return Container(
      child: FutureBuilder(
        future: dio.get("https://api.github.com/orgs/flutterchina/repos"),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          // 请求完成
          if (snapshot.connectionState == ConnectionState.done) {
            Response res = snapshot.data;
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return ListView(
              children: res.data.map<Widget>((e) {
                return ListTile(title: Text(e['full_name']),);
              }).toList()
            );
          }
          return CircularProgressIndicator();
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dioUse(),
    );
  }
}