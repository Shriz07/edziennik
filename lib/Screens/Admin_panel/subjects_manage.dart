import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectsManage extends StatefulWidget {
  @override
  _SubjectsManageState createState() => _SubjectsManageState();
}

class _SubjectsManageState extends State<SubjectsManage> {
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  late List<Subject> subjects;

  Future<List> getSubjects() async {
    if (!loaded) {
      subjects = await _db.getSubjects();

      for (var subject in subjects) {
        subject.leadingTeacher = await _db.getUserWithID(subject.leadingTeacherID);
      }
    }
    loaded = true;
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users manage',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('Zarządzanie przedmiotami'),
        ),
        drawer: MyDrawer(),
        body: FutureBuilder<List>(
          future: getSubjects(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 25.0),
                    panelTitle('Przedmioty'),
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  print('Icon 1 pressed');
                },
                icon: Icon(Icons.add_box, size: 30, color: MyColors.carrotOrange)),
            IconButton(
                onPressed: () {
                  print('Icon 2 pressed');
                },
                icon: Icon(Icons.edit, size: 30, color: MyColors.carrotOrange)),
            IconButton(
                onPressed: () {
                  print('Icon 3 pressed');
                },
                icon: Icon(Icons.delete, size: 30, color: MyColors.carrotOrange)),
          ],
        ),
      ),
    );
  }

  Widget classesListHeader() {
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
                  classInfoField('Nauczyciel', false),
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
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        classInfoField(subjects[index].name, true),
                        classInfoField(subjects[index].leadingTeacher.name + ' ' + subjects[index].leadingTeacher.surname, true),
                      ],
                    ),
                  ),
                ),
              ),
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
