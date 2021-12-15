import 'package:edziennik/Screens/Calendar/calendar.dart';
import 'package:edziennik/Screens/Profile/profile.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    Profile(uid: FirebaseAuth.instance.currentUser!.uid),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
