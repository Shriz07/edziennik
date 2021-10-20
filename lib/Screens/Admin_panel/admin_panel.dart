import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin panel',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('EDziennik Admin'),
        ),
        drawer: MyDrawer(),
        body: const Center(
          child: Text(
            'ADMIN',
          ),
        ),
      ),
    );
  }
}
