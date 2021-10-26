import 'package:edziennik/Screens/Drawer/drawer.dart';
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
            backgroundColor: MyColors.dodgerBlue,
            title: const Text('EDziennik'),
          ),
          drawer: MyDrawer(),
          body: FutureBuilder<List>(
            future: getClasses(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        panelTitle('Dodawanie użytkownika'),
                        userAddContainer(),
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
            IconButton(onPressed: () {}, icon: Icon(Icons.person_add_alt_1, size: 30, color: MyColors.carrotOrange)),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit, size: 30, color: MyColors.carrotOrange)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete, size: 30, color: MyColors.carrotOrange)),
          ],
        ),
      ),
    );
  }

  Widget userAddContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              formFieldTitle('Typ użytkownika:'),
              customDropdownRole(),
              formFieldTitle('Imię:'),
              customFormField(null, 'Imię', _focusName),
              formFieldTitle('Nazwisko:'),
              customFormField(null, 'Nazwisko', _focusSurname),
              if (roleDropdownValue == 'Uczeń') formFieldTitle('Klasa'),
              if (roleDropdownValue == 'Uczeń' && classNames.length > 0) customDropdownClass(),
            ],
          ),
        ),
      ),
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

  Widget customDropdownClass() {
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
                child: Text(selectedClass),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget customDropdownRole() {
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
                child: Text(selectedRole),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
