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
    _nameTextController.text = widget.user.name;
    _surnameTextController.text = widget.user.surname;
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
            backgroundColor: MyColors.greenAccent,
            title: const Text('EDziennik', style: TextStyle(color: Colors.black)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 25.0),
                  panelTitle('Edytowanie użytkownika'),
                  userEditContainer(),
                  bottomOptionsMenu(widget.user),
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
              formFieldTitle('Imię:'),
              customFormField(_nameTextController, 'Imię', _focusName),
              formFieldTitle('Nazwisko:'),
              customFormField(_surnameTextController, 'Imię', _focusSurname),
              formFieldTitle('Rola:'),
              customDropdownRole(),
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

  Widget bottomOptionsMenu(User user) {
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
                onPressed: () async {
                  if (_nameTextController.text != '' && _surnameTextController.text != '' && _roleDropdownValue != '') {
                    user.name = _nameTextController.text;
                    user.surname = _surnameTextController.text;
                    user.role = _roleDropdownValue;
                    await _db.updateUser(user);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UsersManage()));
                  }
                },
                icon: Icon(Icons.save, size: 35, color: MyColors.dodgerBlue)),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close_rounded, size: 35, color: MyColors.dodgerBlue)),
          ],
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
                child: Text(selectedRole),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
