import 'package:flutter/material.dart';

class LearnScaffold extends StatefulWidget {
  const LearnScaffold({ Key? key }) : super(key: key);

  @override
  State<LearnScaffold> createState() => _LearnScaffoldState();
}

class _LearnScaffoldState extends State<LearnScaffold> {

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onAdd(){
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 打洞的位置取决于FloatingActionButton的位置，上面FloatingActionButton的位置为：
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: Text('App'),
        actions: [ // 导航栏右侧菜单
          IconButton(onPressed: (){}, icon: Icon(Icons.share))
        ],
      ),
      drawer: MyDrawer(), // 抽屉
      bottomNavigationBar: Builder(builder: (context) {
        // 特殊底部tab
        // BottomAppBar 组件，它可以和FloatingActionButton配合实现“打洞”效果
        // 打洞的位置取决于FloatingActionButton的位置
        return BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.home)),
              SizedBox(), // 中间位置空出来
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.access_alarm_outlined))
            ],
          ),
        );
        // BottomAppBar的shape属性决定洞的外形，CircularNotchedRectangle实现了一个圆形的外形，

        // 一般底部tab
        return BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('Business')),
            BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('School')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onAdd,
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        removeTop: true, // 移除抽屉菜单顶部默认留白
        context: context, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 38.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: Image.asset(
                        "img/diamond.png",
                        width: 80,
                      ),
                    ),
                  ),
                  Text('哇拉瓦拉',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),  
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('manage'),
                  )
                ],
              )
            
            )
          ],
        )
      ),
    );
  }
}