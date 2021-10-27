import 'package:edziennik/Screens/Authentication/login_page.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirestoreDB _db = FirestoreDB();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile page',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.greenAccent,
          title: const Text(
            'Profil użytkownika',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Scaffold(
          body: Center(
            child: MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => new LoginPage()),
                );
              },
              child: Text('Wyloguj'),
            ),
          ),
        ),
      ),
    );
  }
}
