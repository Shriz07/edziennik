import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student panel',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('EDziennik Uczeń'),
        ),
        drawer: MyDrawer(),
        body: const Center(
          child: Text(
            'STUDENT',
          ),
        ),
      ),
    );
  }
}
