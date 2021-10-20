import 'package:edziennik/Screens/Calendar/calendar.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

import 'teacher_panel.dart';

/*


################################################################################################
#######################                 NIE EDYTOWAĆ                   #########################
################################################################################################



*/
class TeacherHome extends StatefulWidget {
  const TeacherHome({Key? key}) : super(key: key);

  @override
  State<TeacherHome> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<TeacherHome> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    TeacherPanel(),
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
                label: 'Panel nauczyciela',
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
