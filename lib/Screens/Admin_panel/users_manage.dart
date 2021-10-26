import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersManage extends StatefulWidget {
  @override
  _UsersManageState createState() => _UsersManageState();
}

class _UsersManageState extends State<UsersManage> {
  String dropdownValue = 'Wszyscy';
  late List<User> users;
  List<User> admins = [];
  List<User> teachers = [];
  List<User> students = [];
  late List<User> currentList;
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;

  Future<List> getUsers() async {
    if (!loaded) {
      users = await _db.getUsers();
      divideIntoLists();
    }
    if (dropdownValue == 'Wszyscy') {
      currentList = users;
    } else if (dropdownValue == 'Administratorzy') {
      currentList = admins;
    } else if (dropdownValue == 'Nauczyciele') {
      currentList = teachers;
    } else if (dropdownValue == 'Uczniowie') {
      currentList = students;
    } else {
      currentList = users;
    }

    loaded = true;
    return currentList;
  }

  void divideIntoLists() {
    for (var user in users) {
      if (user.role == 'admin') {
        admins.add(user);
      } else if (user.role == 'teacher') {
        teachers.add(user);
      } else if (user.role == 'student') {
        students.add(user);
      }
    }
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
          title: const Text('Zarządzanie użytkownikami'),
        ),
        drawer: MyDrawer(),
        body: FutureBuilder<List>(
          future: getUsers(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 25.0),
                    panelTitle('Użytkownicy'),
                    customDropdownButton(),
                    usersListHeaders(),
                    usersListContainer(),
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
                icon: Icon(Icons.person_add_alt_1, size: 30, color: MyColors.carrotOrange)),
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

  Widget usersListHeaders() {
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
                  userInfoField('Imie', false),
                  userInfoField('Nazwisko', false),
                  userInfoField('Rola', false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget usersListContainer() {
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
          itemCount: currentList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        userInfoField(currentList[index].name, true),
                        userInfoField(currentList[index].surname, true),
                        userInfoField(currentList[index].role, true),
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

  Widget userInfoField(info, bottomBorder) {
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

  Widget customDropdownButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        alignment: AlignmentDirectional.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.carrotOrange,
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
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 42,
          elevation: 16,
          underline: SizedBox(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>['Wszyscy', 'Administratorzy', 'Nauczyciele', 'Uczniowie'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
