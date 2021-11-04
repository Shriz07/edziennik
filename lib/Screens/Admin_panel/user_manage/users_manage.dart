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
          title: Text('Zarządzanie użytkownikami', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
        ),
        body: FutureBuilder<List>(
          future: getUsers(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    panelTitle('Użytkownicy', context),
                    customDropdownButton(),
                    usersListHeaders(),
                    usersListContainer(),
                    bottomOptionsMenu(context, listOfBottomIconsWithActions()),
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

  List<Widget> listOfBottomIconsWithActions() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(
          onPressed: () {
            navigateToAnotherScreen(AddUser());
          },
          icon: Icon(Icons.person_add_alt_1, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () {
            if (_selectedItem == -1) {
              showDialog(context: context, builder: (context) => PopupDialog(title: 'Informacja', message: 'Najpierw wybierz użytkownika', close: 'Zamknij'));
            } else {
              navigateToAnotherScreen(EditUser(user: currentList[_selectedItem]));
            }
          },
          icon: Icon(Icons.edit, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
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
          icon: Icon(Icons.delete, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
    ];
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
                  singleTableCell('Imie', false, context),
                  singleTableCell('Nazwisko', false, context),
                  singleTableCell('Rola', false, context),
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
        height: 6 * MediaQuery.of(context).size.height * 1 / 15 - 50,
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
                  color: _selectedItem == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      singleTableCell(currentList[index].name, true, context),
                      singleTableCell(currentList[index].surname, true, context),
                      singleTableCell(currentList[index].role, true, context),
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

  Widget customDropdownButton() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        width: double.infinity,
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
                child: Text(value, style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
