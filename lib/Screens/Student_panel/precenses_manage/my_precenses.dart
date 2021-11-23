import 'dart:async';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPrecenses extends StatefulWidget {
  @override
  _MyPrecensesState createState() => _MyPrecensesState();
}

class _MyPrecensesState extends State<MyPrecenses> {
  String classDropdownValue = '';
  String subjectDropdownValue = '';

  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<String> subjects = ['matematyka', 'angielski', 'polski'];
  int _selectedNote = -1;

  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();

  Future<List> getSubjects() async {
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'My precenses window',
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
                        SizedBox(height: 25.0),
                        panelTitle('Obecności', context),
                        myPrecensesContainer(),
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

  Widget myPrecensesContainer() {
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
              SizedBox(height: 15),
              formFieldTitle('Przedmiot:', context),
              customDropdownSubjects(),
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
            iconSize: 42,
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
                child: Text(
                  selectedSubject,
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
