import 'package:edziennik/Screens/Drawer/drawer.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersManage extends StatefulWidget {
  @override
  _UsersManageState createState() => _UsersManageState();
}

class _UsersManageState extends State<UsersManage> {
  String dropdownValue = 'Wszyscy';

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
        body: Container(
          alignment: AlignmentDirectional.center,
          child: Column(
            children: <Widget>[
              SizedBox(height: 25.0),
              panelTitle('Użytkownicy'),
              customDropdownButton(),
              usersListContainer(),
              Padding(
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
              ),
            ],
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
        child: Text('USERS LIST'),
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
