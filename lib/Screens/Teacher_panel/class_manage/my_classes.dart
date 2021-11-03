import 'dart:async';
import 'package:edziennik/Screens/Teacher_panel/class_manage/class_selected.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyClasses extends StatefulWidget {
  @override
  _MyClassesState createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  late List<Class> classes;
  int _selectedClass = -1;

  Future<List> getClasses() async {
    if (!loaded) {
      classes = await _db.getClasses();

      // for (var cl in classes) {
      //   cl.supervisingTeacher =
      //       await _db.getUserWithID(cl.supervisingTeacherID);
      // }
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
    return MaterialApp(
      title: 'Selecting class',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.greenAccent,
          title:
              const Text('Wybór klasy', style: TextStyle(color: Colors.black)),
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
                    panelTitle('Moje klasy'),
                    // classesListHeader(),
                    classesListContainer(),
                    bottomApproveBtn(),
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

  Widget bottomApproveBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 70.0, right: 70.0, top: 30.0),
      child: InkWell(
        child: Container(
          width: double.infinity,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Wybierz",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          )),
          decoration: BoxDecoration(
            color: MyColors.dodgerBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        onTap: () {
          print("wybrana klasa");
          if (_selectedClass != -1) {
            navigateToAnotherScreen(ClassSelected());
          }
        },
      ),
    );
  }

  Widget classesListContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 300,
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
                  height: 25.0,
                  color: _selectedClass == index
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      classInfoField(classes[index].name, true),
                      // classInfoField(
                      //     classes[index].supervisingTeacher.name +
                      //         ' ' +
                      //         classes[index].supervisingTeacher.surname,
                      //     true),
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
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            info,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
