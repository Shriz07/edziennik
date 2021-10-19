import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen 2',
      home: Scaffold(
        backgroundColor: MyColors.darkGrey,
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('Screen 2'),
        ),
        drawer: MyDrawer(),
        body: const Center(
          child: Text(
            'Screen 2',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
