import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String roleDropdownValue = 'Uczeń';
  String classDropdownValue = '';
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  late List<Class> classes;
  List<String> classNames = [];

  final _focusName = FocusNode();
  final _focusSurname = FocusNode();

  Future<List> getClasses() async {
    if (!loaded) {
      classes = await _db.getClasses();

      for (var cl in classes) {
        cl.supervisingTeacher = await _db.getUserWithID(cl.supervisingTeacherID);
        classNames.add(cl.name);
      }
    }
    loaded = true;
    return classes;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'Users add',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: GestureDetector(
        onTap: () {
          _focusName.unfocus();
          _focusSurname.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
            backgroundColor: MyColors.greenAccent,
            title: Text('Edziennik', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
          ),
          body: FutureBuilder<List>(
            future: getClasses(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        panelTitle('Dodawanie użytkownika', context),
                        userAddContainer(),
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

  Widget userAddContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 2,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              formFieldTitle('Typ użytkownika:', context),
              customDropdownRole(),
              formFieldTitle('Imię:', context),
              customFormField(null, 'Imię', _focusName, context),
              formFieldTitle('Nazwisko:', context),
              customFormField(null, 'Nazwisko', _focusSurname, context),
              if (roleDropdownValue == 'Uczeń') formFieldTitle('Klasa', context),
              if (roleDropdownValue == 'Uczeń' && classNames.length > 0) customDropdownClass(),
            ],
          ),
        ),
      ),
    );
  }

  Widget customDropdownClass() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
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
            items: classNames.map<DropdownMenuItem<String>>((String selectedClass) {
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

  Widget customDropdownRole() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 1 / 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: DropdownButtonFormField<String>(
            value: roleDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 42,
            elevation: 16,
            onChanged: (String? newSelectedRole) {
              setState(() {
                roleDropdownValue = newSelectedRole!;
              });
            },
            items: <String>['Uczeń', 'Nauczyciel', 'Administrator'].map<DropdownMenuItem<String>>((String selectedRole) {
              return DropdownMenuItem<String>(
                value: selectedRole,
                child: Text(selectedRole, style: TextStyle(fontSize: 3 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
