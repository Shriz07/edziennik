import 'package:edziennik/Screens/Authentication/login_page.dart';
import 'package:edziennik/Utils/firestoreDB.dart';
import 'package:edziennik/models/user.dart';
import 'package:edziennik/style/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart' as FB;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  String uid;

  Profile({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirestoreDB _db = FirestoreDB();
  late User user;

  Future<User> getUser() async {
    user = await _db.getUserWithID(widget.uid);
    return user;
  }

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
        body: FutureBuilder<User>(
          future: getUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              return Center(
                  child: Column(
                children: <Widget>[
                  userInfoContainer(),
                  logoutButton(),
                ],
              ));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget logoutButton() {
    return MaterialButton(
      color: MyColors.dodgerBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      textColor: Colors.white,
      height: 50,
      minWidth: 200,
      onPressed: () async {
        await FB.FirebaseAuth.instance.signOut();
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => new LoginPage()),
        );
      },
      child: Text(
        'Wyloguj',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget userInfoContainer() {
    return Padding(
      padding: const EdgeInsets.all(45.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.dodgerBlue,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset('assets/person.png', height: 250),
            userInfoField(user.role),
            userInfoField('Imię: ' + user.name),
            userInfoField('Nazwisko: ' + user.surname),
            SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }

  Widget userInfoField(text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
      child: Container(
        height: 30.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColors.greenAccent,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}

/*
MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => new LoginPage()),
                );
              },
              child: Text('Wyloguj'),
            ),*/
