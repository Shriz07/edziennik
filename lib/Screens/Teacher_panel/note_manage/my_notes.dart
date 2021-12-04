import 'dart:async';
import 'package:edziennik/Screens/Teacher_panel/note_manage/user_notes.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/custom_widgets/popup_dialog.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  List<User> _users = [];
  bool showUsers = false;
  int _findingSelection = -1;
  final _formkey = GlobalKey<FormState>();

  final FirestoreDB _db = FirestoreDB();
  int _selectedNote = -1;

  final _surnameTextController = TextEditingController();
  final _focusSurname = FocusNode();

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'My notes window',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: GestureDetector(
        onTap: () {
          _focusSurname.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
            backgroundColor: MyColors.greenAccent,
            title: Text('EDziennik', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 25.0),
                  panelTitle('Dodawanie uwagi', context),
                  myNotesContainer(),
                  bottomApproveBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myNotesContainer() {
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 25),
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Znajdź ucznia',
                      style: TextStyle(fontSize: 3.0 * unitHeightValue),
                    ),
                    SizedBox(height: 25),
                    customFormField(_surnameTextController, 'Nazwisko ucznia', _focusSurname, context, (val) => val!.isNotEmpty ? null : 'Wprowadź nazwisko'),
                    SizedBox(height: 5),
                    MaterialButton(
                      color: MyColors.greenAccent,
                      onPressed: () async {
                        _focusSurname.unfocus();
                        if (_formkey.currentState!.validate()) {
                          _users = await _db.getUsersWithSurnameAndRole(_surnameTextController.text, 'uczeń');
                          if (_users.isEmpty) {
                            await showDialog(
                                context: context, builder: (context) => PopupDialog(title: 'Informacja', message: 'Nie znaleziono ucznia o podanym nazwisku.', close: 'Zamknij'));
                          }
                          setState(() {
                            showUsers = true;
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Szukaj',
                        style: TextStyle(fontSize: 3.0 * unitHeightValue),
                      ),
                    ),
                    if (showUsers == true)
                      SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 100),
                          child: ListView.builder(
                            itemCount: _users.length,
                            itemBuilder: (context, findingIndex) {
                              return ListTile(
                                title: Center(
                                    child: Text(
                                  _users[findingIndex].name + ' ' + _users[findingIndex].surname,
                                  style: TextStyle(fontSize: 2.5 * unitHeightValue),
                                )),
                                tileColor: _findingSelection == findingIndex ? Colors.blue : null,
                                onTap: () {
                                  setState(() {
                                    _findingSelection = findingIndex;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noteName(info) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Expanded(
      child: Container(
          child: Center(
            child: Text(
              info,
              style: TextStyle(fontSize: 3 * unitHeightValue, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          )),
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
          if (_findingSelection == -1) {
            showDialog(
                context: context, builder: (context) => PopupDialog(title: 'Informacja', message: 'Najpierw wybierz ucznia, któremu chcesz wystawić uwagę.', close: 'Zamknij'));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserNotes(user: _users[_findingSelection])));
          }
        },
      ),
    );
  }
}
