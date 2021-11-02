import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

import 'pages/multi_example.dart';

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
        body: StartPage(),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(builder: (BuildContext context) => TableMultiExample()),
      ),
    );
  }
}
