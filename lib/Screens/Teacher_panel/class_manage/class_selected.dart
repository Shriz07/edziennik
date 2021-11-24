import 'dart:async';
import 'package:edziennik/Screens/Teacher_panel/class_manage/add_degree.dart';
import 'package:edziennik/Screens/Teacher_panel/class_manage/class_presence.dart';
import 'package:edziennik/Screens/Teacher_panel/events_manage/add_event.dart';
import 'package:edziennik/Screens/Teacher_panel/note_manage/add_note.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/custom_widgets/popup_dialog.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassSelected extends StatefulWidget {
  Class currentClass;
  Subject currentSubject;

  ClassSelected(
      {Key? key, required this.currentClass, required this.currentSubject})
      : super(key: key);

  @override
  _ClassSelectedState createState() => _ClassSelectedState();
}

class _ClassSelectedState extends State<ClassSelected> {
  String teacherDropdownValue = '';
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<User> teachers = [];
  int _selectedStudent = -1;
  late List<User> students;

  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Class window',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: GestureDetector(
        onTap: () {
          _focusName.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
            backgroundColor: MyColors.greenAccent,
            title: Text('EDziennik',
                style: TextStyle(
                    color: Colors.black, fontSize: 3 * unitHeightValue)),
          ),
          body: FutureBuilder<List>(
            future: getClassStudents(), //getTeachers(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        panelTitle(
                            'Klasa ' +
                                widget.currentClass.name +
                                "\n" +
                                widget.currentSubject.name,
                            context),
                        classManagementContainer(),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List> getClassStudents() async {
    if (!loaded) {
      print("class id:" + widget.currentClass.classID);
      students = await _db.getClassStudents(widget.currentClass.classID);
    }
    loaded = true;
    return students;
  }

  Widget classManagementContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            teacherOption("Sprawdź obecność", () {
              navigateToAnotherScreen(
                  ClassPresence(currentClass: widget.currentClass));
            }, context),
            teacherOption("Dodaj wydarzenie", () {
              navigateToAnotherScreen(AddEvent());
            }, context),
            SizedBox(height: 30.0),
            formFieldTitle('Uczniowie: ', context),
            studentsInClassSelection(),
          ],
        ),
      ),
    );
  }

  Widget studentsInClassSelection() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
                height: MediaQuery.of(context).size.height * 1 / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Center(
                          child: Container(
                            color: _selectedStudent == index
                                ? Colors.blue.withOpacity(0.5)
                                : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                singleTableCell(
                                    students[index].name +
                                        " " +
                                        students[index].surname,
                                    true,
                                    context),
                              ],
                            ),
                          ),
                        ),
                        onLongPress: () => {
                          if (_selectedStudent != index)
                            {
                              setState(() {
                                _selectedStudent = index;
                              })
                            }
                        },
                      );
                    })),
          ),
          Column(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    if (_selectedStudent != -1)
                      navigateToAnotherScreen(AddDegree());
                    else
                      showDialog(
                          context: context,
                          builder: (context) => PopupDialog(
                              title: "Informacja",
                              message: "Wybierz ucznia z listy!",
                              close: "Zamknij"));
                  },
                  icon: Icon(Icons.add_box,
                      size: 35.0, color: MyColors.dodgerBlue)),
              SizedBox(height: 25),
              Icon(Icons.view_list, size: 30.0, color: MyColors.dodgerBlue),
              SizedBox(height: 25),
              Icon(Icons.note_alt, size: 35.0, color: MyColors.dodgerBlue),
            ],
          )
        ],
      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void navigateToAnotherScreen(screen) {
    Route route = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(context, route).then(onGoBack);
  }
}
