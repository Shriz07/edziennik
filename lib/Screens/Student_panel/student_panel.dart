import 'package:edziennik/Screens/Student_panel/degrees_manage/my_degrees.dart';
import 'package:edziennik/Screens/Student_panel/precenses_manage/my_presences.dart';
import 'package:edziennik/Screens/Student_panel/note_manage/my_notes.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentPanel extends StatelessWidget {
  String uid;
  late User user;
  final FirestoreDB _db = FirestoreDB();

  StudentPanel({Key? key, required this.uid}) : super(key: key);

  Future<User> getUser() async {
    user = await _db.getUserWithID(uid);
    return user;
  }

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
      home: FutureBuilder<User>(
          future: getUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
                  backgroundColor: MyColors.greenAccent,
                  title: Text('EDziennik Uczeń', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
                ),
                body: Container(
                  alignment: AlignmentDirectional.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      panelTitle('Panel ucznia', context),
                      SizedBox(height: 30.0),
                      panelOption('Oceny', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyDegrees(currentStudent: user)));
                      }, context),
                      panelOption('Uwagi', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyNotes(currentStudent: user)));
                      }, context),
                      panelOption('Obecności', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyPresences(currentStudent: user)));
                      }, context),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
