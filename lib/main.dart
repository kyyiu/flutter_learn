import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/", // 命名为‘/’的路由职位应用的home(首页)
      onGenerateRoute: onGenerateRoute, // 使用路由守卫回调跳转
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '目录'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  buildItem(int idx) {
    return TextButton(onPressed: (){
      if (idx == 0) return;
      Navigator.pushNamed(context, MyRoute.routeName[idx], arguments: {
        "initVal": 9
      });
    }, child: Text(
      MyRoute.chineseRouteName[idx],
      style: TextStyle(
        fontSize: 20.0,
        decoration: TextDecoration.none
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: MyRoute.routeName.length,
        itemBuilder: (BuildContext context, int idx) => buildItem(idx)),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
