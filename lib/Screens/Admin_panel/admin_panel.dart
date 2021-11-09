import 'package:edziennik/Screens/Admin_panel/class_manage/class_manage.dart';
import 'package:edziennik/Screens/Admin_panel/subject_manage/subjects_manage.dart';
import 'package:edziennik/Screens/Admin_panel/user_manage/users_manage.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Admin panel',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
            backgroundColor: MyColors.greenAccent,
            title: Text('EDziennik', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
          ),
          body: Container(
            alignment: AlignmentDirectional.center,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50.0),
                panelTitle('Panel administratora', context),
                SizedBox(height: 25.0),
                panelOption('Użytkownicy', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UsersManage()));
                }, context),
                panelOption('Klasy', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClassManage()));
                }, context),
                panelOption('Przedmioty', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubjectsManage()));
                }, context),
              ],
            ),
          )),
    );
  }
}
