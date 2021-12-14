import 'package:edziennik/Screens/Teacher_panel/class_manage/my_subjects.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/Screens/Teacher_panel/class_manage/my_classes.dart';
import 'package:edziennik/Screens/Teacher_panel/events_manage/my_events.dart';
import 'package:edziennik/Screens/Teacher_panel/note_manage/my_notes.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Teacher panel',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
          backgroundColor: MyColors.greenAccent,
          title: Text('EDziennik Nauczyciel', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
        ),
        body: Container(
          alignment: AlignmentDirectional.center,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              panelTitle('Panel nauczyciela', context),
              SizedBox(height: 30.0),
              panelOption('Moje przedmioty', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MySubjects()));
              }, context),
              panelOption('Uwagi', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyNotes()));
              }, context),
            ],
          ),
        ),
      ),
    );
  }
}
