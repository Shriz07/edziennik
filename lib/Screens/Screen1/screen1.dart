import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen 1',
      home: Scaffold(
        backgroundColor: MyColors.darkGrey,
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('Screen 1'),
        ),
        body: const Center(
          child: Text(
            'Screen 1',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
