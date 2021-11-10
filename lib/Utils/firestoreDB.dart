import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/models/user.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDB extends ChangeNotifier {
  final CollectionReference _userCollectionReference = FirebaseFirestore.instance.collection('users');
  final CollectionReference _classCollectionReference = FirebaseFirestore.instance.collection('classes');
  final CollectionReference _subjectsCollectionReference = FirebaseFirestore.instance.collection('subjects');

  Future getUsers() async {
    try {
      List<User> users = [];
      await _userCollectionReference.get().then(
            (docs) => {
              for (var doc in docs.docs)
                {
                  users.add(new User(userID: doc.get('uid'), name: doc.get('name'), surname: doc.get('surname'), role: doc.get('role'))),
                }
            },
          );
      return users;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getUsersWithRole(role) async {
    try {
      List<User> users = [];
      await _userCollectionReference.get().then(
            (docs) => {
              for (var doc in docs.docs)
                {
                  if (doc.get('role') == role)
                    {
                      users.add(new User(userID: doc.id, name: doc.get('name'), surname: doc.get('surname'), role: doc.get('role'))),
                    }
                }
            },
          );
      return users;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getUserWithID(uid) async {
    try {
      late User user;
      await _userCollectionReference.doc(uid).get().then(
            (snapshot) => {
              user = new User(userID: snapshot['uid'], name: snapshot['name'], surname: snapshot['surname'], role: snapshot['role']),
            },
          );
      return user;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getClasses() async {
    try {
      List<Class> classes = [];
      await _classCollectionReference.get().then(
            (docs) => {
              for (var doc in docs.docs)
                {
                  classes.add(new Class(classID: doc.id, name: doc.get('name'), supervisingTeacherID: doc.get('supervisingTeacherID'))),
                }
            },
          );
      return classes;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getUsersIDsInClass(classID) async {
    try {
      List<String> listOfIDs = [];
      await _classCollectionReference.doc(classID).collection('students').get().then(
            (docs) => {
              for (var doc in docs.docs) {listOfIDs.add(doc.id)}
            },
          );
      return listOfIDs;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getUsersWithSurnameAndRole(surname, role) async {
    try {
      List<User> users = [];
      await _userCollectionReference.get().then(
            (docs) => {
              for (var doc in docs.docs)
                {
                  if (doc.get('role') == role && doc.get('surname') == surname)
                    {users.add(new User(userID: doc.get('uid'), name: doc.get('name'), surname: doc.get('surname'), role: doc.get('role')))}
                }
            },
          );
      return users;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future deleteUserFromClass(classID, userID) async {
    try {
      await _classCollectionReference.doc(classID).collection('students').doc(userID).delete();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future addUserToClass(classID, userID) async {
    try {
      await _classCollectionReference.doc(classID).collection('students').doc(userID).set({});
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getSubjects() async {
    try {
      List<Subject> subjects = [];
      await _subjectsCollectionReference.get().then((docs) => {
            for (var doc in docs.docs)
              {
                subjects.add(new Subject(subjectID: doc.id, name: doc.get('name'), leadingTeacherID: doc.get('leadingTeacherID'))),
              }
          });
      return subjects;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future addSubject(Subject subject) async {
    try {
      if (subject.subjectID != '') {
        await _subjectsCollectionReference.doc(subject.subjectID).set(subject.toMap());
      } else {
        await _subjectsCollectionReference.add(subject.toMap());
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future deleteSubject(Subject subject) async {
    try {
      await _subjectsCollectionReference.doc(subject.subjectID).delete();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future updateUser(User user) async {
    try {
      await _userCollectionReference.doc(user.userID).set(user.toMap());
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future deleteUser(User user) async {
    try {
      await _userCollectionReference.doc(user.userID).delete();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
