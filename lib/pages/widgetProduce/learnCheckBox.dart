import 'package:flutter/material.dart';

class LearnCheckBox extends StatefulWidget {
  const LearnCheckBox({ Key? key }) : super(key: key);

  @override
  State<LearnCheckBox> createState() => _LearnCheckBoxState();
}

class _LearnCheckBoxState extends State<LearnCheckBox> {
  bool _switchSelected = true; // 单选开关状态
  bool _checkboxSelected = true; //维护复选框状态

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Switch(value: _switchSelected, onChanged: (nextVal) {
          setState(() {
            _switchSelected = nextVal;
          });
        }),
        Checkbox(value: _checkboxSelected, activeColor: Colors.greenAccent, onChanged: (nextVal) {
          setState(() {
            _checkboxSelected = nextVal!;
          });
        })
      ],)
    );
  }
}