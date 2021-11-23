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
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Selecting class',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
          backgroundColor: MyColors.greenAccent,
          title: Text('Wybór klasy', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
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
                    panelTitle('Moje klasy', context),
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
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.only(left: 70.0, right: 70.0, top: 30.0),
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width * 1 / 2,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Wybierz",
              style: TextStyle(fontSize: 3 * unitHeightValue, color: Colors.white),
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
          itemCount: classes.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Center(
                child: Container(
                  color: _selectedClass == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      singleTableCell(classes[index].name, true, context),
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
}
