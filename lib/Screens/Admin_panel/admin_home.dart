import 'package:edziennik/Screens/Calendar/calendar.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

import 'admin_panel.dart';

/*


################################################################################################
#######################                 NIE EDYTOWAĆ                   #########################
################################################################################################



*/
class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<AdminHome> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    AdminPanel(),
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
              icon: Icon(Icons.home),
              label: 'Panel administratora',
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
