import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class TeacherPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher panel',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('EDziennik Nauczyciel'),
        ),
        drawer: MyDrawer(),
        body: const Center(
          child: Text(
            'TEACHER',
          ),
        ),
      ),
    );
  }
}
