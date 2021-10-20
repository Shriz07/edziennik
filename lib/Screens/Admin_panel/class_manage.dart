import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class ClassManage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class manage',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('Zarządzanie klasami'),
        ),
        drawer: MyDrawer(),
        body: const Center(
          child: Text(
            'TEST',
          ),
        ),
      ),
    );
  }
}
