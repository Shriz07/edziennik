import 'dart:async';

import 'package:edziennik/Screens/Admin_panel/user_manage/add_user.dart';
import 'package:edziennik/Screens/Admin_panel/user_manage/edit_user.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/custom_widgets/popup_dialog.dart';
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
  List<User> users = [];
  List<User> admins = [];
  List<User> teachers = [];
  List<User> students = [];
  List<User> currentList = [];
  final FirestoreDB _db = FirestoreDB();
  bool loaded = false;
  int _selectedItem = -1;

  Future<List> getUsers() async {
    if (!loaded) {
      users.clear();
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
    admins.clear();
    teachers.clear();
    students.clear();
    for (var user in users) {
      if (user.role == 'administrator') {
        admins.add(user);
      } else if (user.role == 'nauczyciel') {
        teachers.add(user);
      } else if (user.role == 'uczeń') {
        students.add(user);
      }
    }
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
      title: 'Users manage',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.greenAccent,
          title: const Text('Zarządzanie użytkownikami', style: TextStyle(color: Colors.black)),
        ),
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
                  navigateToAnotherScreen(AddUser());
                },
                icon: Icon(Icons.person_add_alt_1, size: 30, color: MyColors.dodgerBlue)),
            IconButton(
                onPressed: () {
                  if (_selectedItem == -1) {
                    showDialog(context: context, builder: (context) => PopupDialog(title: 'Informacja', message: 'Najpierw wybierz użytkownika', close: 'Zamknij'));
                  } else {
                    navigateToAnotherScreen(EditUser(user: currentList[_selectedItem]));
                  }
                },
                icon: Icon(Icons.edit, size: 30, color: MyColors.dodgerBlue)),
            IconButton(
                onPressed: () {
                  if (_selectedItem == -1) {
                    showDialog(context: context, builder: (context) => PopupDialog(title: 'Informacja', message: 'Najpierw wybierz użytkownika', close: 'Zamknij'));
                  } else {
                    _db.deleteUser(currentList[_selectedItem]);
                    setState(() {
                      loaded = false;
                    });
                  }
                },
                icon: Icon(Icons.delete, size: 30, color: MyColors.dodgerBlue)),
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
            return InkWell(
              child: Center(
                child: Container(
                  height: 25.0,
                  color: _selectedItem == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
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
              onLongPress: () => {
                if (_selectedItem != index)
                  {
                    setState(() {
                      _selectedItem = index;
                    })
                  }
              },
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
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
        height: 60,
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
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: dropdownValue,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            dropdownColor: MyColors.dodgerBlue,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            iconSize: 42,
            elevation: 16,
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
      ),
    );
  }
}
