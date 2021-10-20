import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('EDziennik Kalendarz'),
        ),
        drawer: MyDrawer(),
        body: const Center(
          child: Text(
            'Calendar',
          ),
        ),
      ),
    );
  }
}
