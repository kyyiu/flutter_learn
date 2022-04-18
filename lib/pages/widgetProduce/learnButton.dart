import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LearnButton extends StatefulWidget {
  const LearnButton({Key? key}) : super(key: key);

  @override
  State<LearnButton> createState() => _LearnButtonState();
}

class _LearnButtonState extends State<LearnButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: () {}, child: Text('我是ElevatedButton')),
        TextButton(onPressed: () {}, child: Text('我是TextButton')),
        OutlinedButton(onPressed: () {}, child: Text('我是OutlinedButton')),
        IconButton(onPressed: () {}, icon: Icon(Icons.thumb_up)),
        ElevatedButton.icon(
            onPressed: () {},
            label: Text('我是带图标的ElevatedButton'),
            icon: Icon(Icons.ac_unit)),
        OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.access_alarm_rounded),
            label: Text('我是带图标的OutlinedButton')),
        TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.access_time_filled_sharp),
            label: Text('我是带图标的TextButton'))
      ],
    ));
  }
}
