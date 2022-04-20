import 'package:flutter/material.dart';

class LearnForm extends StatefulWidget {
  const LearnForm({ Key? key }) : super(key: key);

  @override
  State<LearnForm> createState() => _LearnFormState();
}

class _LearnFormState extends State<LearnForm> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  TextEditingController _formNameController = TextEditingController();
  TextEditingController _formPassController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  FocusNode fn1 = FocusNode();
  FocusNode fn2 = FocusNode();
  FocusScopeNode? focusScopeNode;

  // 焦点可以通过FocusNode和FocusScopeNode来控制，
  // 默认情况下，焦点由FocusScope来管理，它代表焦点控制范围，
  // 可以在这个范围内可以通过FocusScopeNode在输入框之间移动焦点、设置默认焦点等。
  // 我们可以通过FocusScope.of(context) 来获取Widget树中默认的FocusScopeNode

  @override
  void initState() {
    super.initState();
    // 设置默认值
    _nameController.text = "我的名字";
    // 设置选中,从第三个字符开始选中后面的字符
    _nameController.selection = TextSelection(baseOffset: 2, extentOffset: _nameController.text.length);
    // 通过监听器监打印输入框内容
    _nameController.addListener(() {
      print(_nameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "用户名",
            hintText: "用户名或邮箱",
            prefixIcon: Icon(Icons.person)
          ),
          onChanged: (e) { // 通过事件回调打印输入框内容
            print(e);
          },
        ),
        TextField(
          controller: _passController,
          decoration: InputDecoration(
            labelText: "密码",
            hintText: "输入密码",
            prefixIcon: Icon(Icons.lock)
          ),
          obscureText: true,
        ),
        ElevatedButton(onPressed: (){
          print(_nameController.text);
        }, child: Text('打印输入框内容')),
        Container(
          height: 1,
          decoration: BoxDecoration(color: Colors.orange),
        ),
        TextField(
          autofocus: true,
          focusNode: fn1,
          decoration: InputDecoration(labelText: 'inp1'),
        ),
        TextField(
          focusNode: fn2,
          decoration: InputDecoration(labelText: 'inp2'),
        ),
        Builder(builder: (ctx) {
          return Column(children: [
            ElevatedButton(onPressed: (){
              // 将焦点从第一个textfiled移到第二个
              // 写法1. FocusScope.of(context).requestFocus(f2)
              // 写法2
              if (null == focusScopeNode) {
                focusScopeNode = FocusScope.of(context);
              }
              focusScopeNode!.requestFocus(fn2);
            }, child: Text('切换焦点')), 
            ElevatedButton(onPressed: (){
                // 当所有编辑框都失去焦点，键盘就会收起
                fn1.unfocus();
                fn2.unfocus();
              },child: Text('隐藏键盘')),
          ],);
        }),
        Container(
          height: 10,
          decoration: BoxDecoration(color: Colors.brown),
        ),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: [
            TextFormField(
              controller: _formNameController,
              decoration: InputDecoration(
                labelText: '表单用户名',
                hintText: '表单用户名或邮箱',
                icon: Icon(Icons.person)
              ),
              validator: (val) {
                return val!.trim().isEmpty ? null : '用户名不能为空';
              },
            ),
            TextFormField(
              controller: _formPassController,
              decoration: InputDecoration(
                labelText: "表单密码",
                hintText: "表单密码",
                icon: Icon(Icons.lock)
              ),
              obscureText: true,
              validator: (val) {
                return val!.trim().length > 5 ? null : "密码不能少于6位";
              },
            ),
            Padding(padding: EdgeInsets.only(top: 28),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 通过_formkey.currentState 获取Formstate
                          // 调用validate（）方法校验用户名密码是否合法，校验
                          // 通过后再提交数据
                          if ((_formKey.currentState as FormState).validate()) {
                            // 验证通过提交数据
                          }
                        },
                        child: Padding(padding: EdgeInsets.all(16),child: Text("登录"),),))
                  ],
                )
              ),
          ],),
        )
      ],),
    );
  }
}