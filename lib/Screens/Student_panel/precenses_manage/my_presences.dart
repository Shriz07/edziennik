import 'dart:async';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPresences extends StatefulWidget {
  User currentStudent;

  MyPresences({Key? key, required this.currentStudent});

  @override
  _MyPresencesState createState() => _MyPresencesState();
}

class _MyPresencesState extends State<MyPresences> {
  String classDropdownValue = '';
  String subjectDropdownValue = '';
  final FirestoreDB _db = FirestoreDB();
  int _selectedDegree = -1;

  bool subjectLoaded = false;
  List<Subject> subjects = [];
  int _selectedNote = -1;
  Map<String, dynamic> precenses = {};

  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();

  Future<List> getSubjects() async {
    if (subjectLoaded == false) {
      subjectLoaded = true;
      return subjects = await _db.getSubjects();
    }
    return subjects;
  }

  Future getPresences(subjectID) async {
    precenses = await _db.getUserPresences(subjectID, widget.currentStudent.userID);
    return precenses;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My degrees window',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: GestureDetector(
        onTap: () {
          _focusName.unfocus();
        },
        child: FutureBuilder<List>(
          future: getSubjects(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
                  backgroundColor: MyColors.greenAccent,
                  title: Text('EDziennik', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
                ),
                body: FutureBuilder<List>(
                  future: getSubjects(),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      return SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 25.0),
                              panelTitle('Obecności', context),
                              myDegreesContainer(),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
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

  Widget myDegreesContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              formFieldTitle('Przedmiot:', context),
              customDropdownSubjects(),
              formFieldTitle('Obecności: ', context),
              myDegreesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myDegreesList() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Flexible(
              child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: new ListView.builder(
              itemCount: precenses.length,
              itemBuilder: (BuildContext context, int index) {
                String key = precenses.keys.elementAt(index);
                return new Column(children: [
                  new ListTile(
                    title: Text(
                      '$key - ' + (precenses[key] == true ? 'obecny' : 'nieobecny'),
                      style: TextStyle(fontSize: 2.5 * unitHeightValue),
                    ),
                  )
                ]);
              },
            ),
          ))
        ],
      ),
    );
  }

  Widget degreeInfo(info, bottomBorder, flex) {
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

  Widget customDropdownSubjects() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: DropdownButtonFormField<String>(
            value: subjectDropdownValue == '' ? null : subjectDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 42,
            elevation: 16,
            onChanged: (String? newSelectedSubject) async {
              precenses = await getPresences(newSelectedSubject);
              print(precenses);
              setState(() {
                subjectDropdownValue = newSelectedSubject!;
              });
            },
            items: subjects.map<DropdownMenuItem<String>>((Subject selectedSubject) {
              return DropdownMenuItem<String>(
                value: selectedSubject.subjectID,
                child: Text(
                  selectedSubject.name,
                  style: TextStyle(fontSize: 3 * unitHeightValue),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
