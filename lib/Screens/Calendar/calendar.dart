import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.greenAccent,
          title: const Text(
            'EDziennik Kalendarz',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: const Center(
          child: Text(
            'Calendar',
          ),
        ),
      ),
    );
  }
}
