import 'package:flutter/material.dart';

class LearnWidgetful extends StatefulWidget {
  const LearnWidgetful({ Key? key }) : super(key: key);

  @override
  State<LearnWidgetful> createState() => _LearnWidgetfulState();
}

class _LearnWidgetfulState extends State<LearnWidgetful> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('我是learn'),
    );
  }
}