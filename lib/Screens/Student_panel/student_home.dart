import 'package:edziennik/Screens/Calendar/calendar.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

import 'student_panel.dart';

/*


################################################################################################
#######################                 NIE EDYTOWAĆ                   #########################
################################################################################################



*/
class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<StudentHome> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    StudentPanel(),
    Calendar(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: MyColors.dodgerBlue),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Panel ucznia',
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
      ),
    );
  }
}
