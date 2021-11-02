import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/Screens/Teacher_panel/class_manage/my_classes.dart';
import 'package:edziennik/Screens/Teacher_panel/events_manage/my_events.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher panel',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.greenAccent,
          title: const Text('EDziennik Nauczyciel',
              style: TextStyle(color: Colors.black)),
        ),
        body: Container(
          alignment: AlignmentDirectional.center,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              panelTitle('Nauczyciel [ID]'),
              SizedBox(height: 30.0),
              panelOption('Moje klasy', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyClasses()));
              }),
              panelOption('Uwagi', () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => MyClasses()));
              }),
              panelOption('Wydarzenia', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyEvents()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
