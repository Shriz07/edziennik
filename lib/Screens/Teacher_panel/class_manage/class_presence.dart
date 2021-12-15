import 'dart:async';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ClassPresence extends StatefulWidget {
  Class currentClass;
  Subject currentSubject;
  ClassPresence({Key? key, required this.currentClass, required this.currentSubject}) : super(key: key);

  @override
  _ClassPresenceState createState() => _ClassPresenceState();
}

final _focusName = FocusNode();

class _ClassPresenceState extends State<ClassPresence> {
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<User> teachers = [];
  int _selectedStudent = -1;
  late List<User> students;
  late DateTime _dateSelected;

  Map<String, bool> values = {};

  bool _isSelected = false;

  Future<List> getClassStudents() async {
    if (!loaded) {
      print("class id:" + widget.currentClass.classID);
      students = await _db.getClassStudents(widget.currentClass.classID);
      for (var student in students) {
        values[student.userID] = false;
      }
    }
    loaded = true;
    return students;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                        panelTitle('Klasa ' + widget.currentClass.name, context),
                        teacherOption("Obecności", null, context),
                        SizedBox(height: 15.0),
                        formFieldTitle('Data: ', context),
                        dateField(),
                        SizedBox(height: 15.0),
                        studentsListContainer(),
                        SizedBox(height: 15.0),
                        bottomOptionsMenu(context, listOfBottomIconsWithActions()),
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

  Widget dateField() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Container(
        child: DateTimeFormField(
          dateTextStyle: TextStyle(fontSize: 2.5 * unitHeightValue),
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 2.5 * unitHeightValue),
            labelStyle: TextStyle(fontSize: 2.5 * unitHeightValue),
            errorStyle: TextStyle(color: Colors.redAccent),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            border: const OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            suffixIcon: Icon(Icons.event_note),
            labelText: 'Wybierz date',
          ),
          mode: DateTimeFieldPickerMode.date,
          autovalidateMode: AutovalidateMode.always,
          onDateSelected: (DateTime value) {
            print(value);
            _dateSelected = value;
            _isSelected = true;
          },
        ),
      ),
    );
  }

  Widget studentsListContainer() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 3,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: new ListView(
            children: values.keys.map((String key) {
          return new CheckboxListTile(
              title: Text(students.firstWhere((element) => element.userID == key).name + " " + students.firstWhere((element) => element.userID == key).surname,
                  style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              value: values[key],
              onChanged: (bool? value) {
                setState(() {
                  values[key] = value!;
                });
              });
        }).toList()),
      ),
    );
  }

  List<Widget> listOfBottomIconsWithActions() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(
          onPressed: () async {
            if (_isSelected == true) {
              String dateString = DateFormat('dd-MM-yyyy').format(DateTime.parse(_dateSelected.toString()));
              values.keys.forEach((key) async {
                await _db.addUserPresence(widget.currentSubject.subjectID, key, dateString, values[key]);
              });
            }
            Navigator.pop(context);
          },
          icon: Icon(Icons.save, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
    ];
  }
}
