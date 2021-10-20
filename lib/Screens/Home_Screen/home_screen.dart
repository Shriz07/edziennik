import 'package:edziennik/Screens/Admin_panel/admin_home.dart';
import 'package:edziennik/Screens/Calendar/calendar.dart';
import 'package:edziennik/Screens/Student_panel/student_home.dart';
import 'package:edziennik/Screens/Teacher_panel/teacher_home.dart';
import 'package:edziennik/Screens/Test_screen/test_screen.dart';
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
    TestScreen(),
    AdminHome(),
    TeacherHome(),
    StudentHome(),
    Calendar(),
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
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              label: 'Test',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.outlined_flag),
              label: 'Admin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              label: 'Nauczyciel',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Uczeń',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Kalendarz',
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
