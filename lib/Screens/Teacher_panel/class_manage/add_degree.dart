import 'dart:async';
import 'package:date_field/date_field.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDegree extends StatefulWidget {
  @override
  _AddDegreeState createState() => _AddDegreeState();
}

class _AddDegreeState extends State<AddDegree> {
  String studentDropdownValue = '';
  String subjectDropdownValue = '';
  String degreeDropdownValue = '';

  final FirestoreDB _db = FirestoreDB();
  final User? user = FirebaseAuth.instance.currentUser;

  bool loaded = false;
  List<String> subjects = ['matematyka', 'angielski', 'polski'];
  List<String> classes = ['2A', '3D', '6C'];
  List<String> degrees = ['1', '2', '3', '4', '5'];
  int _selectedEvent = -1;
  List<String> students = [
    'Emilia Kamińska',
    'Michał Kowalski',
    'Bartosz Górski',
    'Monika Kołodziej',
  ];

  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();

  Future<List> getSubjects() async {
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'My events window',
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
            future: getSubjects(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 1.0),
                        panelTitle('Dodaj/edytuj ocene', context),
                        addDegreeContainer(),
                        bottomOptionsMenu(
                            context, listOfBottomIconsWithActions())
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

  Widget addDegreeContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 1.5,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 1),
              formFieldTitle('Uczeń: ', context),
              customDropdownStudents(),
              formFieldTitle('Przedmiot:', context),
              customDropdownSubjects(),
              formFieldTitle('Ocena:', context),
              customDropdownDegrees(),
              formFieldTitle('Data:', context),
              dateField(),
              formFieldTitle('Komentarz do oceny:', context),
              customTextField(),
            ],
          ),
        ),
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
            iconSize: 28,
            elevation: 16,
            onChanged: (String? newSelectedSubject) {
              setState(() {
                subjectDropdownValue = newSelectedSubject!;
              });
            },
            items: subjects
                .map<DropdownMenuItem<String>>((String selectedSubject) {
              return DropdownMenuItem<String>(
                value: selectedSubject,
                child: Text(selectedSubject,
                    style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget customDropdownDegrees() {
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
            value: degreeDropdownValue == '' ? null : degreeDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 28,
            elevation: 16,
            onChanged: (String? newSelectedClass) {
              setState(() {
                degreeDropdownValue = newSelectedClass!;
              });
            },
            items:
                degrees.map<DropdownMenuItem<String>>((String selectedDegree) {
              return DropdownMenuItem<String>(
                value: selectedDegree,
                child: Text(selectedDegree,
                    style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget customDropdownStudents() {
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
            value: studentDropdownValue == '' ? null : studentDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 28,
            elevation: 16,
            onChanged: (String? newSelectedEventType) {
              setState(() {
                studentDropdownValue = newSelectedEventType!;
              });
            },
            items: students
                .map<DropdownMenuItem<String>>((String selectedStudent) {
              return DropdownMenuItem<String>(
                value: selectedStudent,
                child: Text(selectedStudent,
                    style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget customTextField() {
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
          child: TextField(),
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
          validator: (e) =>
              (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
          onDateSelected: (DateTime value) {
            print(value);
          },
        ),
      ),
    );
  }

  List<Widget> listOfBottomIconsWithActions() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          icon: Icon(Icons.save,
              size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded,
              size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
    ];
  }
}
