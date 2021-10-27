import 'package:edziennik/Screens/Calendar/calendar.dart';
import 'package:edziennik/Screens/Profile/profile.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

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
    Profile(),
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
          child: FancyBottomNavigation(
            barBackgroundColor: Colors.greenAccent,
            tabs: [
              TabData(iconData: Icons.home, title: 'Menu'),
              TabData(iconData: Icons.calendar_today, title: 'Kalendarz'),
              TabData(iconData: Icons.person, title: 'Profil'),
            ],
            onTabChangedListener: (position) {
              setState(() {
                _onItemTapped(position);
              });
            },
          ),
        ),
      ),
    );
  }
}
