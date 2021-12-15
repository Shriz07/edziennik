import 'dart:async';
import 'package:edziennik/Screens/Teacher_panel/class_manage/add_degree.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/degree.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentDegrees extends StatefulWidget {
  Subject currentSubject;
  User currentStudent;

  StudentDegrees({Key? key, required this.currentStudent, required this.currentSubject});

  @override
  _StudentGradesState createState() => _StudentGradesState();
}

class _StudentGradesState extends State<StudentDegrees> {
  final _focusName = FocusNode();
  List<Degree> degrees = [];
  final FirestoreDB _db = FirestoreDB();
  int _selectedDegree = -1;

  bool loaded = false;

  Future<List> getDegrees() async {
    if (!loaded) {
      degrees.clear();
      degrees = await _db.getUserDegreesFromSubject(widget.currentStudent.userID, widget.currentSubject.subjectID);
      loaded = true;
    }

    return degrees;
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
      debugShowCheckedModeBanner: false,
      title: 'User grades',
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
            title: Text('Oceny ucznia - ' + widget.currentSubject.name, style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
          ),
          body: FutureBuilder<List>(
            future: getDegrees(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  child: Column(
                    children: <Widget>[
                      panelTitle(widget.currentStudent.name + ' ' + widget.currentStudent.surname, context),
                      degreeListHeader(),
                      userDegreesContainer(),
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
      ),
    );
  }

  List<Widget> listOfBottomIconsWithActions() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(
          onPressed: () async {
            navigateToAnotherScreen(AddDegree(
                currentStudent: widget.currentStudent,
                currentSubject: widget.currentSubject,
                degree: new Degree(userID: '', grade: '', date: DateTime.now(), comment: '', weight: '')));
          },
          icon: Icon(Icons.add_box, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () {
            if (_selectedDegree != -1) {
              navigateToAnotherScreen(AddDegree(currentStudent: widget.currentStudent, currentSubject: widget.currentSubject, degree: degrees[_selectedDegree]));
            }
          },
          icon: Icon(Icons.edit, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
    ];
  }

  Widget userDegreesContainer() {
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
          itemCount: degrees.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Center(
                child: Container(
                  color: _selectedDegree == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      testWidget(DateFormat('dd-MM-yyyy').format(DateTime.parse(degrees[index].date.toString())), true, 2),
                      testWidget(degrees[index].grade, true, 1),
                      testWidget(degrees[index].comment.split(' ').first, true, 2),
                      testWidget(degrees[index].weight, true, 1),
                    ],
                  ),
                ),
              ),
              onTap: () => {
                if (_selectedDegree != index)
                  {
                    setState(() {
                      _selectedDegree = index;
                    })
                  }
              },
            );
          },
        ),
      ),
    );
  }

  Widget testWidget(info, bottomBorder, flex) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Flexible(
      flex: flex,
      child: Container(
        child: Center(
          child: Text(
            info,
            style: TextStyle(fontSize: 2.5 * unitHeightValue, fontWeight: FontWeight.bold),
          ),
        ),
        decoration: bottomBorder == true
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              )
            : null,
      ),
    );
  }

  Widget degreeListHeader() {
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
                  testWidget('Data', false, 2),
                  testWidget('Ocena', false, 1),
                  testWidget('Typ', false, 2),
                  testWidget('Waga', false, 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
