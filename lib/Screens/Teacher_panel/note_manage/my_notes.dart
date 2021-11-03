import 'dart:async';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  String classDropdownValue = '';
  String subjectDropdownValue = '';

  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<String> subjects = ['matematyka', 'angielski', 'polski'];
  List<String> classes = ['2A', '3D', '6C'];
  List<String> notes = [
    'Krzychu pił piwo na lekcji',
    'Maciuś brzydko pachnie',
    'Kasia ma za duży dekolt'
  ];
  int _selectedNote = -1;

  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();

  Future<List> getSubjects() async {
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My notes window',
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
            backgroundColor: MyColors.greenAccent,
            title:
                const Text('EDziennik', style: TextStyle(color: Colors.black)),
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
                        panelTitle('Wystawione uwagi'),
                        myNotesContainer(),
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

  Widget myNotesContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 500,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              formFieldTitle('Przedmiot:'),
              customDropdownSubjects(),
              formFieldTitle('Klasa:'),
              customDropdownClasses(),
              formFieldTitle('Uwagi: '),
              myNotesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myNotesList() {
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
                child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Center(
                          child: Container(
                            height: 25.0,
                            color: _selectedNote == index
                                ? Colors.blue.withOpacity(0.5)
                                : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                noteName(notes[index]),
                              ],
                            ),
                          ),
                        ),
                        // onLongPress: () => {
                        //   if (_selectedNote != index)
                        //     {
                        //       setState(() {
                        //         _selectedNote = index;
                        //       })
                        //     }
                        // },
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

  Widget noteName(info) {
    return Expanded(
      child: Container(
          child: Center(
            child: Text(
              info,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          )),
    );
  }

  Widget formFieldTitle(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
    );
  }

  Widget customFormField(controller, hintText, fnode) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        focusNode: fnode,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: MyColors.carrotOrange, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget customDropdownSubjects() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        height: 60,
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
                child: Text(selectedSubject),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget customDropdownClasses() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: DropdownButtonFormField<String>(
            value: classDropdownValue == '' ? null : classDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 42,
            elevation: 16,
            onChanged: (String? newSelectedClass) {
              setState(() {
                classDropdownValue = newSelectedClass!;
              });
            },
            items:
                classes.map<DropdownMenuItem<String>>((String selectedClass) {
              return DropdownMenuItem<String>(
                value: selectedClass,
                child: Text(selectedClass),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
