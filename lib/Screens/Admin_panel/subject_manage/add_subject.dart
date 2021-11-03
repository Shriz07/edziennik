import 'package:edziennik/Screens/Admin_panel/subject_manage/subjects_manage.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/custom_widgets/popup_dialog.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSubject extends StatefulWidget {
  Subject subject;

  AddSubject({Key? key, required this.subject}) : super(key: key);

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  String teacherDropdownValue = '';
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<User> teachers = [];

  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();

  Future<List> getTeachers() async {
    if (!loaded) {
      teachers = await _db.getUsersWithRole('nauczyciel');
      _nameTextController.text = widget.subject.name;
      teacherDropdownValue = widget.subject.name != '' ? widget.subject.leadingTeacher.surname : '';
    }
    loaded = true;
    return teachers;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Subject add',
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
            future: getTeachers(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        panelTitle('Dodawanie przedmiotu', context),
                        userAddContainer(),
                        bottomOptionsMenu(context, listOfBottomIconsWithActions(widget.subject)),
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

  List<Widget> listOfBottomIconsWithActions(Subject subject) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(
          onPressed: () async {
            if (teacherDropdownValue != '' && _nameTextController.text != '') {
              User teacher = teachers.firstWhere((element) => element.surname == teacherDropdownValue);
              subject.name = _nameTextController.text;
              subject.leadingTeacherID = teacher.userID;
              await _db.addSubject(subject);
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.save, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
    ];
  }

  Widget userAddContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 1.8,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              formFieldTitle('Nazwa:', context),
              customFormField(_nameTextController, 'Nazwa przedmiotu', _focusName, context),
              formFieldTitle('Nauczyciel prowadzący:', context),
              customDropdownTeacher(),
            ],
          ),
        ),
      ),
    );
  }

  Widget customDropdownTeacher() {
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
            value: teacherDropdownValue == '' ? null : teacherDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 42,
            elevation: 16,
            onChanged: (String? newSelectedTeacher) {
              setState(() {
                teacherDropdownValue = newSelectedTeacher!;
              });
            },
            items: teachers.map((user) => user.surname).toList().map<DropdownMenuItem<String>>((String selectedTeacher) {
              return DropdownMenuItem<String>(
                value: selectedTeacher,
                child: Text(selectedTeacher, style: TextStyle(fontSize: 3 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
