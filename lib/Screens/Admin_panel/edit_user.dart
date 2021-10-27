import 'package:edziennik/Utils/firestoreDB.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit user',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.dodgerBlue,
          title: const Text('Edytowanie użytkownika'),
        ),
        body: Scaffold(
          body: Center(
            child: Text(widget.user.name),
          ),
        ),
      ),
    );
  }
}
