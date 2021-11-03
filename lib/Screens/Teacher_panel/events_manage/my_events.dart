import 'dart:async';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyEvents extends StatefulWidget {
  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  String classDropdownValue = '';
  String subjectDropdownValue = '';

  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<String> subjects = ['matematyka', 'angielski', 'polski'];
  List<String> classes = ['2A', '3D', '6C'];
  List<String> events = ['Sprawdzian 2A', 'Kartkowka 3D', 'Wycieczka 6C'];
  int _selectedEvent = -1;
  List<String> students = ['Emilia Kamińska', 'Michał Kowalski', 'Bartosz Górski', 'Monika Kołodziej'];

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
                        panelTitle('Moje wydarzenia', context),
                        myEventsContainer(),
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

  Widget myEventsContainer() {
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
              formFieldTitle('Przedmiot:'),
              customDropdownSubjects(),
              formFieldTitle('Klasa:'),
              customDropdownClasses(),
              formFieldTitle('Wydarzenia: '),
              myEventsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myEventsList() {
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
                child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Center(
                          child: Container(
                            color: _selectedEvent == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                eventName(events[index]),
                              ],
                            ),
                          ),
                        ),
                        // onLongPress: () => {
                        //   if (_selectedEvent != index)
                        //     {
                        //       setState(() {
                        //         _selectedEvent = index;
                        //       })
                        //     }
                        // },
                      );
                    })),
          ),
          Column(
            children: <Widget>[
              Icon(Icons.person_add, size: 4 * unitHeightValue, color: MyColors.dodgerBlue),
              SizedBox(height: 25),
              Icon(Icons.edit, size: 4 * unitHeightValue, color: MyColors.dodgerBlue),
              SizedBox(height: 25),
              Icon(Icons.delete, size: 4 * unitHeightValue, color: MyColors.dodgerBlue),
            ],
          )
        ],
      ),
    );
  }

  Widget eventName(info) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Expanded(
      child: Container(
          child: Center(
            child: Text(
              info,
              style: TextStyle(fontSize: 3 * unitHeightValue, fontWeight: FontWeight.bold),
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
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Text(
      title,
      style: TextStyle(fontSize: 3 * unitHeightValue, fontWeight: FontWeight.bold),
    );
  }

  Widget customFormField(controller, hintText, fnode) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        focusNode: fnode,
        style: TextStyle(fontSize: 3 * unitHeightValue),
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
            items: subjects.map<DropdownMenuItem<String>>((String selectedSubject) {
              return DropdownMenuItem<String>(
                value: selectedSubject,
                child: Text(selectedSubject, style: TextStyle(fontSize: 3 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget customDropdownClasses() {
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
            value: classDropdownValue == '' ? null : classDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 42,
            elevation: 16,
            onChanged: (String? newSelectedClass) {
              setState(() {
                classDropdownValue = newSelectedClass!;
              });
            },
            items: classes.map<DropdownMenuItem<String>>((String selectedClass) {
              return DropdownMenuItem<String>(
                value: selectedClass,
                child: Text(selectedClass, style: TextStyle(fontSize: 3 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
