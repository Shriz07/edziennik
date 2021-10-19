import 'package:edziennik/Screens/Screen1/screen1.dart';
import 'package:edziennik/Screens/Screen2/screen2.dart';
import 'package:edziennik/Screens/Screen3/screen3.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Screen1(),
    Screen2(),
    Screen3(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: MyColors.dodgerBlue),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Screen 1',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              label: 'Screen 2',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Screen 3',
            ),
          ],
          selectedItemColor: MyColors.carrotOrange,
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
