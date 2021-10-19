import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen 3',
      home: Scaffold(
        backgroundColor: MyColors.darkGrey,
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('Screen 3'),
        ),
        drawer: MyDrawer(),
        body: const Center(
          child: Text(
            'Screen 3',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
