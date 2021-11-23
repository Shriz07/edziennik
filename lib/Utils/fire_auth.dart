import 'package:edziennik/Screens/Admin_panel/admin_home.dart';
import 'package:edziennik/Screens/Student_panel/student_home.dart';
import 'package:edziennik/Screens/Teacher_panel/teacher_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireAuth {
  // For registering a new user
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  // For signing in an user (have already registered)
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw new UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw new WrongPasswordException();
      } else {
        throw new LoginException();
      }
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  authorizeAccess(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((value) => {
          if (value.get('role') == 'administrator')
            {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()))}
          else if (value.get('role') == 'nauczyciel')
            {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeacherHome()))}
          else if (value.get('role') == 'uczeń')
            {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHome()))}
          else
            {print('invalid role')}
        });
  }
}

class UserNotFoundException implements Exception {
  String errorMessage() {
    return 'Użytkownik nie istnieje';
  }
}

class WrongPasswordException implements Exception {
  String errorMessage() {
    return 'Nieprawidłowe hasło';
  }
}

class LoginException implements Exception {
  String errorMessage() {
    return 'Wystąpił błąd. Sprawdź wprowadzone dane.';
  }
}
