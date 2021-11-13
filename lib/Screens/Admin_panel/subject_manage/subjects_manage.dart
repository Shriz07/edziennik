import 'dart:async';

import 'package:edziennik/Screens/Admin_panel/subject_manage/add_subject.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/custom_widgets/popup_dialog.dart';
import 'package:edziennik/custom_widgets/yes_no_alert.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectsManage extends StatefulWidget {
  @override
  _SubjectsManageState createState() => _SubjectsManageState();
}

class _SubjectsManageState extends State<SubjectsManage> {
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<Subject> subjects = [];
  int _selectedSubject = -1;

  Future<List> getSubjects() async {
    if (!loaded) {
      subjects.clear();
      subjects = await _db.getSubjects();

      for (var subject in subjects) {
        subject.leadingTeacher = await _db.getUserWithID(subject.leadingTeacherID);
      }
    }
    loaded = true;
    return subjects;
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      loaded = false;
    });
  }

  void navigateToAnotherScreen(screen) {
    Route route = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(context, route).then(onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Subjects manage',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
          backgroundColor: MyColors.greenAccent,
          title: Text('Zarządzanie przedmiotami', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
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
                    panelTitle('Przedmioty', context),
                    classesListHeader(),
                    classesListContainer(),
                    bottomOptionsMenu(context, listOfBottomIconsWithActions()),
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

  List<Widget> listOfBottomIconsWithActions() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(onPressed: addSubjectIconClick(), icon: Icon(Icons.add_box, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(onPressed: editSubjectIconClick(), icon: Icon(Icons.edit, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(onPressed: deleteSubjectIconClick(), icon: Icon(Icons.delete, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
    ];
  }

  VoidCallback addSubjectIconClick() {
    return () {
      navigateToAnotherScreen(AddSubject(subject: Subject(subjectID: '', name: '', leadingTeacherID: '')));
    };
  }

  VoidCallback editSubjectIconClick() {
    return () {
      if (_selectedSubject != -1) {
        Subject subject = subjects.elementAt(_selectedSubject);
        navigateToAnotherScreen(AddSubject(subject: subject));
      } else {
        showDialog(
            context: context, builder: (context) => PopupDialog(title: 'Informacja', message: 'Najpierw wybierz przedmiot z listy, który chcesz edytować.', close: 'Zamknij'));
      }
    };
  }

  VoidCallback deleteSubjectIconClick() {
    return () {
      if (_selectedSubject != -1) {
        Subject subject = subjects.elementAt(_selectedSubject);
        showDialog(
          context: context,
          builder: (context) => YesNoAlert(
            message: 'Czy napewno chcesz usunąć przedmiot ' + subject.name + ', prowadzony przez ' + subject.leadingTeacher.name + ' ' + subject.leadingTeacher.surname + '?',
            yesAction: () {
              _db.deleteSubject(subject);
              subjects.remove(subject);
              setState(
                () {
                  _selectedSubject = -1;
                },
              );
              Navigator.of(context).pop();
            },
            noAction: () {
              Navigator.of(context).pop();
            },
          ),
        );
      } else {
        showDialog(context: context, builder: (context) => PopupDialog(title: 'Informacja', message: 'Najpierw wybierz przedmiot z listy, który chcesz usunąć.', close: 'Zamknij'));
      }
    };
  }

  Widget classesListHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  singleTableCell('Nazwa', false, context),
                  singleTableCell('Nauczyciel', false, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget classesListContainer() {
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
                      singleTableCell(subjects[index].leadingTeacher.name + ' ' + subjects[index].leadingTeacher.surname, true, context),
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
