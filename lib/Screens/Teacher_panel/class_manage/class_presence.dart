import 'dart:async';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassPresence extends StatefulWidget {
  @override
  _ClassPresenceState createState() => _ClassPresenceState();
}

final _focusName = FocusNode();

class _ClassPresenceState extends State<ClassPresence> {
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<User> teachers = [];
  int _selectedStudent = -1;
  List<String> students = ['Emilia Kamińska', 'Michał Kowalski', 'Bartosz Górski', 'Monika Kołodziej'];

  bool _isSelected = false;

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
                        teacherOption("Obecności", null, context),
                        SizedBox(height: 15.0),
                        formFieldTitle('Data: '),
                        dateField(),
                        SizedBox(height: 15.0),
                        studentsListContainer(),
                        SizedBox(height: 15.0),
                        bottomOptionsMenu(),
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

  Widget formFieldTitle(title) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 3 * unitHeightValue, fontWeight: FontWeight.bold),
    );
  }

  Widget dateField() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        child: DateTimeFormField(
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.black45, fontSize: 3 * unitHeightValue),
            labelStyle: TextStyle(color: Colors.black45, fontSize: 3 * unitHeightValue),
            errorStyle: TextStyle(color: Colors.redAccent),
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.event_note),
            labelText: 'Wybierz date',
          ),
          mode: DateTimeFieldPickerMode.date,
          autovalidateMode: AutovalidateMode.always,
          validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
          onDateSelected: (DateTime value) {
            print(value);
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
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return Card(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      new CheckboxListTile(
                        title: Text(students[index], style: TextStyle(fontSize: 3 * unitHeightValue)),
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        value: _isSelected,
                        onChanged: (value) {
                          setState(() {
                            _isSelected = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bottomOptionsMenu() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.save, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close_rounded, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
          ],
        ),
      ),
    );
  }
}
