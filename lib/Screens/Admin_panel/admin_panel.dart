import 'package:edziennik/Screens/Admin_panel/class_manage.dart';
import 'package:edziennik/Screens/Admin_panel/subjects_manage.dart';
import 'package:edziennik/Screens/Admin_panel/users_manage.dart';
import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin panel',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColors.dodgerBlue,
            title: const Text('EDziennik'),
          ),
          drawer: MyDrawer(),
          body: Container(
            alignment: AlignmentDirectional.center,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50.0),
                panelTitle('Panel administratora'),
                SizedBox(height: 70.0),
                panelOption('Użytkownicy', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UsersManage()));
                }),
                panelOption('Klasy', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClassManage()));
                }),
                panelOption('Przedmioty', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectsManage()));
                }),
              ],
            ),
          )),
    );
  }
}
