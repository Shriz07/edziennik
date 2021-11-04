import 'package:edziennik/Screens/Admin_panel/user_manage/users_manage.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/custom_widgets/panel_widgets.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditUser extends StatefulWidget {
  User user;

  EditUser({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final FirestoreDB _db = FirestoreDB();

  String _roleDropdownValue = '';
  final _nameTextController = TextEditingController();
  final _surnameTextController = TextEditingController();
  final _focusName = FocusNode();
  final _focusSurname = FocusNode();

  @override
  void initState() {
    _nameTextController.text = widget.user.name;
    _surnameTextController.text = widget.user.surname;
    _roleDropdownValue = widget.user.role;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return MaterialApp(
      title: 'User edit',
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 25.0),
                  panelTitle('Edytowanie użytkownika', context),
                  userEditContainer(),
                  bottomOptionsMenu(context, listOfBottomIconsWithActions(widget.user)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userEditContainer() {
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
              formFieldTitle('Imię:', context),
              customFormField(_nameTextController, 'Imię', _focusName, context),
              formFieldTitle('Nazwisko:', context),
              customFormField(_surnameTextController, 'Imię', _focusSurname, context),
              formFieldTitle('Rola:', context),
              customDropdownRole(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> listOfBottomIconsWithActions(User user) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return <Widget>[
      IconButton(
          onPressed: () async {
            if (_nameTextController.text != '' && _surnameTextController.text != '' && _roleDropdownValue != '') {
              user.name = _nameTextController.text;
              user.surname = _surnameTextController.text;
              user.role = _roleDropdownValue;
              await _db.updateUser(user);
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

  Widget customDropdownRole() {
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
            value: _roleDropdownValue == '' ? null : _roleDropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 42,
            elevation: 16,
            onChanged: (String? newSelectedRole) {
              setState(() {
                _roleDropdownValue = newSelectedRole!;
              });
            },
            items: <String>['uczeń', 'nauczyciel', 'administrator'].map<DropdownMenuItem<String>>((String selectedRole) {
              return DropdownMenuItem<String>(
                value: selectedRole,
                child: Text(selectedRole, style: TextStyle(fontSize: 2.5 * unitHeightValue)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
