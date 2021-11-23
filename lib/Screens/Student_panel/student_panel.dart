import 'package:edziennik/Screens/Student_panel/degrees_manage/my_degrees.dart';
import 'package:edziennik/Screens/Student_panel/precenses_manage/my_precenses.dart';
import 'package:edziennik/Screens/Student_panel/note_manage/my_notes.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Student panel',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
          backgroundColor: MyColors.greenAccent,
          title: Text('EDziennik Uczeń',
              style: TextStyle(
                  color: Colors.black, fontSize: 3 * unitHeightValue)),
        ),
        body: Container(
          alignment: AlignmentDirectional.center,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              panelTitle('Uczeń [ID]', context),
              SizedBox(height: 30.0),
              panelOption('Oceny', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyDegrees()));
              }, context),
              panelOption('Uwagi', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyNotes()));
              }, context),
              panelOption('Obecności', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyPrecenses()));
              }, context),
            ],
          ),
        ),
      ),
    );
  }
}
