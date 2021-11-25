import 'dart:async';
import 'package:edziennik/Screens/Teacher_panel/class_manage/class_selected.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_classes.dart';

class MySubjects extends StatefulWidget {
  @override
  _MySubjectsState createState() => _MySubjectsState();
}

class _MySubjectsState extends State<MySubjects> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  late List<Subject> subjects;
  int _selectedSubject = -1;

  Future<List> getSubjects() async {
    if (!loaded) {
      subjects = await _db.getTeachersSubjects(user!.uid);
    }
    loaded = true;
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Selecting class',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
          backgroundColor: MyColors.greenAccent,
          title: Text('Wybór przedmiotu', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
        ),
        body: FutureBuilder<List>(
          future: getSubjects(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 25.0),
                    panelTitle('Moje przedmioty', context),
                    // subjectsListHeader(),
                    subjectsListContainer(),
                    bottomApproveBtn(),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget bottomApproveBtn() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.only(left: 70.0, right: 70.0, top: 30.0),
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width * 1 / 2,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Wybierz",
              style: TextStyle(fontSize: 3 * unitHeightValue, color: Colors.white),
            ),
          )),
          decoration: BoxDecoration(
            color: MyColors.dodgerBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        onTap: () {
          if (_selectedSubject != -1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyClasses(currentSubject: subjects[_selectedSubject])));
          }
        },
      ),
    );
  }

  Widget subjectsListContainer() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 2,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Center(
                child: Container(
                  color: _selectedSubject == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      singleTableCell(subjects[index].name, true, context),
                      // classInfoField(
                      //     subjects[index].supervisingTeacher.name +
                      //         ' ' +
                      //         subjects[index].supervisingTeacher.surname,
                      //     true),
                    ],
                  ),
                ),
              ),
              onLongPress: () => {
                if (_selectedSubject != index)
                  {
                    setState(() {
                      _selectedSubject = index;
                    })
                  }
              },
            );
          },
        ),
      ),
    );
  }
}
