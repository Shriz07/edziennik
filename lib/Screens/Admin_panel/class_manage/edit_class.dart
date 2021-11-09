import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditClass extends StatefulWidget {
  Class currentClass;

  EditClass({Key? key, required this.currentClass}) : super(key: key);

  @override
  _EditClassState createState() => _EditClassState();
}

class _EditClassState extends State<EditClass> {
  final _formkey = GlobalKey<FormState>();
  String _teacherDropdownValue = '';
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  List<User> _teachers = [];
  int _selectedStudent = -1;
  List<User> _students = [];

  final _nameTextController = TextEditingController();
  final _surnameTextController = TextEditingController();
  final _focusName = FocusNode();
  final _focusSurname = FocusNode();

  Future<List> getStudentsInClass() async {
    List<String> userIDsInClass = await _db.getUsersIDsInClass(widget.currentClass.classID);
    for (var id in userIDsInClass) {
      print(id);
      User user = await _db.getUserWithID(id);
      _students.add(user);
    }
    return _students;
  }

  Future<List> getTeachersAndStudents() async {
    if (!loaded) {
      _teachers.clear();
      _students.clear();
      _teachers = await _db.getUsersWithRole('nauczyciel');
      _nameTextController.text = widget.currentClass.name;
      _teacherDropdownValue = widget.currentClass.name != '' ? widget.currentClass.supervisingTeacher.surname : '';
      await getStudentsInClass();
    }
    loaded = true;
    return _teachers;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Class edit',
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
            title: Text('Edziennik', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
          ),
          body: FutureBuilder<List>(
            future: getTeachersAndStudents(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        panelTitle('Edytowanie klasy', context),
                        classEditContainer(),
                        bottomOptionsMenu(context, listOfBottomIconsWithActions()),
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

  Widget classEditContainer() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 1.9,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              formFieldTitle('Nazwa klasy:', context),
              customFormField(_nameTextController, 'Nazwa klasy', _focusName, context),
              formFieldTitle('Nauczyciel prowadzący:', context),
              customDropdownTeacher(),
              formFieldTitle('Uczniowie: ', context),
              studentsInClassSelection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget studentsInClassSelection() {
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
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Center(
                          child: Container(
                            color: _selectedStudent == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                singleTableCell(_students[index].name + ' ' + _students[index].surname, true, context),
                              ],
                            ),
                          ),
                        ),
                        onLongPress: () => {
                          if (_selectedStudent != index)
                            {
                              setState(() {
                                _selectedStudent = index;
                              })
                            }
                        },
                      );
                    })),
          ),
          Column(
            children: <Widget>[
              IconButton(onPressed: addUserToClass(), icon: Icon(Icons.person_add, size: 35.0, color: MyColors.dodgerBlue)),
              SizedBox(height: 25),
              IconButton(onPressed: deleteUserFromClass(), icon: Icon(Icons.delete, size: 35.0, color: MyColors.dodgerBlue))
            ],
          )
        ],
      ),
    );
  }

  VoidCallback addUserToClass() {
    return () {
      showFindUserDialog();
      /*setState(() {
          loaded = false;
        });*/
    };
  }

  VoidCallback deleteUserFromClass() {
    return () {
      if (_selectedStudent == -1) {
        print('Nie wybrano studenta');
      } else {
        _db.deleteUserFromClass(widget.currentClass.classID, _students[_selectedStudent].userID);
        setState(() {
          loaded = false;
        });
      }
    };
  }

  void showFindUserDialog() async {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Znajdź ucznia',
                          style: TextStyle(fontSize: 3.0 * unitHeightValue),
                        ),
                        SizedBox(height: 25),
                        customFormField(_surnameTextController, 'Nazwisko ucznia', _focusSurname, context),
                        SizedBox(height: 5),
                        MaterialButton(
                          color: MyColors.frenchLime,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Szukaj',
                            style: TextStyle(fontSize: 3.0 * unitHeightValue),
                          ),
                        ),
                        SizedBox(height: 25),
                        MaterialButton(
                          color: MyColors.dodgerBlue,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Anuluj',
                            style: TextStyle(fontSize: 3.0 * unitHeightValue, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
            value: _teacherDropdownValue == '' ? null : _teacherDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 42,
            elevation: 16,
            onChanged: (String? newSelectedTeacher) {
              setState(() {
                _teacherDropdownValue = newSelectedTeacher!;
              });
            },
            items: _teachers.map((user) => user.surname).toList().map<DropdownMenuItem<String>>((String selectedTeacher) {
              return DropdownMenuItem<String>(
                value: selectedTeacher,
                child: Text(selectedTeacher, style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              );
            }).toList(),
          ),
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
          icon: Icon(Icons.save, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
    ];
  }
}
