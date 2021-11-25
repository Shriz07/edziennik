import 'dart:async';
import 'package:date_field/date_field.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/event.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEvent extends StatefulWidget {
  Class currentClass;
  Subject currentSubject;
  AddEvent({Key? key, required this.currentClass, required this.currentSubject}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String classDropdownValue = '';
  String subjectDropdownValue = '';
  String eventTypeDropdownValue = '';

  final FirestoreDB _db = FirestoreDB();

  bool loaded = false;
  List<String> eventTypes = ['Sprawdzian', 'Kartkowka', 'Test', 'Inne'];
  int _selectedEvent = -1;
  late DateTime _selectedDate;
  bool _dateWasSelected = false;

  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();

  @override
  Widget build(BuildContext context) {
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
          _focusName.unfocus();
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
                children: <Widget>[SizedBox(height: 1.0), panelTitle('Nowe wydarzenie', context), addEventContainer(), bottomOptionsMenu(context, listOfBottomIconsWithActions())],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addEventContainer() {
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
              SizedBox(height: 1),
              formFieldTitle('Przedmiot:', context),
              fieldWithText(widget.currentSubject.name),
              formFieldTitle('Klasa:', context),
              fieldWithText(widget.currentClass.name),
              formFieldTitle('Typ wydarzenia: ', context),
              customDropdownEventTypes(),
              formFieldTitle('Data:', context),
              dateField(),
              formFieldTitle('Opis wydarzenia:', context),
              customTextField(),
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
          child: Text(
            text,
            style: TextStyle(fontSize: unitHeightValue * 3),
          ),
        ),
      ),
    );
  }

  Widget customDropdownEventTypes() {
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
            value: eventTypeDropdownValue == '' ? null : eventTypeDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 28,
            elevation: 16,
            onChanged: (String? newSelectedEventType) {
              setState(() {
                eventTypeDropdownValue = newSelectedEventType!;
              });
            },
            items: eventTypes.map<DropdownMenuItem<String>>((String selectedEventType) {
              return DropdownMenuItem<String>(
                value: selectedEventType,
                child: Text(selectedEventType, style: TextStyle(fontSize: 2.5 * unitHeightValue)),
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
            controller: _nameTextController,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: null,
          ),
        ),
      ),
    );
  }

  Widget dateField() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Container(
        child: DateTimeFormField(
          dateTextStyle: TextStyle(fontSize: 2.5 * unitHeightValue),
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 2.5 * unitHeightValue),
            labelStyle: TextStyle(fontSize: 2.5 * unitHeightValue),
            errorStyle: TextStyle(color: Colors.redAccent),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            border: const OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            suffixIcon: Icon(Icons.event_note),
            labelText: 'Wybierz date',
          ),
          mode: DateTimeFieldPickerMode.date,
          autovalidateMode: AutovalidateMode.always,
          onDateSelected: (DateTime value) {
            print(value);
            _selectedDate = value;
            _dateWasSelected = true;
          },
        ),
      ),
    );
  }

  List<Widget> listOfBottomIconsWithActions() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(
          onPressed: () async {
            if (_dateWasSelected == true) {
              Event event = Event(
                  date: _selectedDate,
                  type: eventTypeDropdownValue,
                  description: _nameTextController.text,
                  subject: widget.currentSubject.name,
                  classID: widget.currentClass.classID);
              await _db.addEvent(event);
              Navigator.pop(context);
            }
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
