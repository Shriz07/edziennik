import 'dart:async';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/custom_widgets/popup_dialog.dart';
import 'package:edziennik/models/degree.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddDegree extends StatefulWidget {
  Subject currentSubject;
  User currentStudent;
  Degree degree;

  AddDegree({Key? key, required this.currentStudent, required this.currentSubject, required this.degree});

  @override
  _AddDegreeState createState() => _AddDegreeState();
}

class _AddDegreeState extends State<AddDegree> {
  String _degreeDropdownValue = '';
  String _weightDropdownValue = '';

  final FirestoreDB _db = FirestoreDB();

  bool loaded = false;
  List<String> degrees = ['1', '2', '3', '4', '5'];
  List<String> weights = ['1', '2', '3'];

  final _commentTextController = TextEditingController();
  final _focusComment = FocusNode();

  @override
  Widget build(BuildContext context) {
    _degreeDropdownValue = widget.degree.grade;
    _weightDropdownValue = widget.degree.weight;
    _commentTextController.text = widget.degree.comment;
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'My events window',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: GestureDetector(
        onTap: () {
          _focusComment.unfocus();
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
                  SizedBox(height: 1.0),
                  panelTitle('Dodaj/edytuj ocene', context),
                  addDegreeContainer(),
                  bottomOptionsMenu(context, listOfBottomIconsWithActions())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addDegreeContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 1 / 1.5,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              formFieldTitle('Przedmiot:', context),
              fieldWithText(widget.currentSubject.name),
              formFieldTitle('Uczeń: ', context),
              fieldWithText(widget.currentStudent.name + ' ' + widget.currentStudent.surname),
              formFieldTitle('Ocena:', context),
              customDropdownDegrees(),
              formFieldTitle('Waga', context),
              customDropdownWeights(),
              formFieldTitle('Komentarz do oceny:', context),
              customTextField(),
              formFieldTitle('Data:', context),
              fieldWithText(DateFormat('dd-MM-yyyy').format(DateTime.parse(DateTime.now().toString()))),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldWithText(text) {
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
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: unitHeightValue * 3),
            ),
          ),
        ),
      ),
    );
  }

  Widget customDropdownDegrees() {
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
            value: _degreeDropdownValue == '' ? null : _degreeDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 28,
            elevation: 16,
            onChanged: (String? newSelectedClass) {
              setState(() {
                _degreeDropdownValue = newSelectedClass!;
              });
            },
            items: degrees.map<DropdownMenuItem<String>>((String selectedDegree) {
              return DropdownMenuItem<String>(
                value: selectedDegree,
                child: Text(selectedDegree, style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget customDropdownWeights() {
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
            value: _weightDropdownValue == '' ? null : _weightDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 28,
            elevation: 16,
            onChanged: (String? newSelectedClass) {
              setState(() {
                _weightDropdownValue = newSelectedClass!;
              });
            },
            items: weights.map<DropdownMenuItem<String>>((String selectedWeight) {
              return DropdownMenuItem<String>(
                value: selectedWeight,
                child: Text(selectedWeight, style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
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
            focusNode: _focusComment,
            controller: _commentTextController,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: null,
            style: TextStyle(fontSize: 2.5 * unitHeightValue),
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
            if (_degreeDropdownValue != '' && _commentTextController.text != '' && _weightDropdownValue != '') {
              widget.degree.userID = widget.currentStudent.userID;
              widget.degree.comment = _commentTextController.text;
              widget.degree.grade = _degreeDropdownValue;
              widget.degree.weight = _weightDropdownValue;
              await _db.addDegree(widget.degree, widget.currentSubject.subjectID);
            } else {
              showDialog(context: context, builder: (context) => PopupDialog(title: "Informacja", message: "Wypełnij wszystkie pola.", close: "Zamknij"));
            }
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
