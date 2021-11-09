import 'dart:async';
import 'package:edziennik/Screens/Teacher_panel/class_manage/class_presence.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassSelected extends StatefulWidget {
  @override
  _ClassSelectedState createState() => _ClassSelectedState();
}

class _ClassSelectedState extends State<ClassSelected> {
  String teacherDropdownValue = '';
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<User> teachers = [];
  int _selectedStudent = -1;
  List<String> students = ['Emilia Kamińska', 'Michał Kowalski', 'Bartosz Górski', 'Monika Kołodziej'];

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
            title: Text('EDziennik', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
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
                        panelTitle('Klasa [NAZWA]', context),
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
              navigateToAnotherScreen(ClassPresence());
            }, context),
            teacherOption("Dodaj wydarzenie", null, context),
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
                            color: _selectedStudent == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                singleTableCell(students[index], true, context),
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
              Icon(Icons.person_add, size: 35.0, color: MyColors.dodgerBlue),
              SizedBox(height: 25),
              Icon(Icons.edit, size: 30.0, color: MyColors.dodgerBlue),
              SizedBox(height: 25),
              Icon(Icons.delete, size: 35.0, color: MyColors.dodgerBlue),
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
