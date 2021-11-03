import 'dart:async';

import 'package:edziennik/Screens/Admin_panel/class_manage/edit_class.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassManage extends StatefulWidget {
  @override
  _ClassManageState createState() => _ClassManageState();
}

class _ClassManageState extends State<ClassManage> {
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  late List<Class> classes;
  int _selectedClass = -1;

  Future<List> getClasses() async {
    if (!loaded) {
      classes = await _db.getClasses();

      for (var cl in classes) {
        cl.supervisingTeacher = await _db.getUserWithID(cl.supervisingTeacherID);
      }
    }
    loaded = true;
    return classes;
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void navigateToAnotherScreen(screen) {
    Route route = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(context, route).then(onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Users manage',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
          backgroundColor: MyColors.greenAccent,
          title: Text('Zarządzanie klasami', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
        ),
        body: FutureBuilder<List>(
          future: getClasses(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 25.0),
                    panelTitle('Klasy', context),
                    classesListHeader(),
                    classesListContainer(),
                    bottomOptionsMenu(),
                  ],
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

  Widget bottomOptionsMenu() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  navigateToAnotherScreen(EditClass(currentClass: Class(classID: '', name: '', supervisingTeacherID: '')));
                },
                icon: Icon(Icons.add_box, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
            IconButton(
                onPressed: () {
                  if (_selectedClass != -1) {
                    navigateToAnotherScreen(EditClass(currentClass: classes[_selectedClass]));
                  }
                },
                icon: Icon(Icons.edit, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
            IconButton(
                onPressed: () {
                  print('Icon 3 pressed');
                },
                icon: Icon(Icons.delete, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
          ],
        ),
      ),
    );
  }

  Widget classesListHeader() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
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
                  classInfoField('Nazwa', false),
                  classInfoField('Wychowawca', false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget classesListContainer() {
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
          itemCount: classes.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Center(
                child: Container(
                  color: _selectedClass == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      classInfoField(classes[index].name, true),
                      classInfoField(classes[index].supervisingTeacher.name + ' ' + classes[index].supervisingTeacher.surname, true),
                    ],
                  ),
                ),
              ),
              onLongPress: () => {
                if (_selectedClass != index)
                  {
                    setState(() {
                      _selectedClass = index;
                    })
                  }
              },
            );
          },
        ),
      ),
    );
  }

  Widget classInfoField(info, bottomBorder) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            info,
            style: TextStyle(fontSize: 3 * unitHeightValue, fontWeight: FontWeight.bold),
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
}
