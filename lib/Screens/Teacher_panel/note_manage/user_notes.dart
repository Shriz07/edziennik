import 'dart:async';
import 'package:date_field/date_field.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/custom_widgets/popup_dialog.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserNotes extends StatefulWidget {
  User user;

  UserNotes({Key? key, required this.user});

  @override
  _UserNotesState createState() => _UserNotesState();
}

class _UserNotesState extends State<UserNotes> {
  final _formkey = GlobalKey<FormState>();
  final FirestoreDB _db = FirestoreDB();
  int _selectedNote = -1;

  bool loaded = false;

  final _noteTextController = TextEditingController();
  final _focusNote = FocusNode();

  List<String> notes = [];

  Future<List> getNotes() async {
    if (!loaded) {
      notes = await _db.getUserNotes(widget.user.userID);
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User notes',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: GestureDetector(
        onTap: () {
          _focusNote.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 3 * MediaQuery.of(context).size.height * 1 / 40,
            backgroundColor: MyColors.greenAccent,
            title: Text('EDziennik', style: TextStyle(color: Colors.black, fontSize: 3 * unitHeightValue)),
          ),
          body: FutureBuilder<List>(
            future: getNotes(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[panelTitle('Uwagi', context), addNoteContainer(), bottomOptionsMenu(context, listOfBottomIconsWithActions())],
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

  Widget addNoteContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          formFieldTitle(widget.user.name + ' ' + widget.user.surname, context),
          studentMarks(),
        ],
      ),
    );
  }

  Widget studentMarks() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              height: MediaQuery.of(context).size.height * 1 / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Center(
                      child: Container(
                        color: _selectedNote == index ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            customSingleTableCell(notes[index], true, context),
                          ],
                        ),
                      ),
                    ),
                    onTap: () => {
                      if (_selectedNote != index)
                        {
                          setState(() {
                            _selectedNote = index;
                          })
                        }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAddNoteDialog() async {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Text(
                              'Podaj treść uwagi',
                              style: TextStyle(fontSize: 3.0 * unitHeightValue),
                            ),
                            SizedBox(height: 25),
                            customTextField(),
                            MaterialButton(
                              color: MyColors.greenAccent,
                              onPressed: () async {
                                _focusNote.unfocus();
                                if (_formkey.currentState!.validate()) {
                                  await _db.addNoteToUser(widget.user.userID, _noteTextController.text);
                                  Navigator.pop(context);
                                }
                                _noteTextController.text = '';
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                'Dodaj uwagę',
                                style: TextStyle(fontSize: 3.0 * unitHeightValue),
                              ),
                            ),
                            MaterialButton(
                              color: MyColors.greenAccent,
                              onPressed: () async {
                                _noteTextController.text = '';
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                'Anuluj',
                                style: TextStyle(fontSize: 3.0 * unitHeightValue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget customTextField() {
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
          child: TextField(
            focusNode: _focusNote,
            controller: _noteTextController,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: null,
            style: TextStyle(fontSize: 2.5 * unitHeightValue),
          ),
        ),
      ),
    );
  }

  Widget customSingleTableCell(info, bottomBorder, context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            info,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 2.5 * unitHeightValue,
              fontWeight: FontWeight.bold,
            ),
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

  List<Widget> listOfBottomIconsWithActions() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(
          onPressed: () async {
            return showAddNoteDialog();
          },
          icon: Icon(Icons.add_box, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () async {
            if (_selectedNote != -1) {
              _db.deleteNoteFromUser(widget.user.userID, notes[_selectedNote]);
              setState(() {
                _selectedNote = -1;
              });
            } else {
              await showDialog(context: context, builder: (context) => PopupDialog(title: 'Informacja', message: 'Najpierw wybierz uwagę do usunięcia', close: 'Zamknij'));
            }
          },
          icon: Icon(Icons.delete, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded, size: 4 * unitHeightValue, color: MyColors.dodgerBlue)),
    ];
  }
}
