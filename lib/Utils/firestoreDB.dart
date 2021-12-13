import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edziennik/models/class.dart';
import 'package:edziennik/models/degree.dart';
import 'package:edziennik/models/event.dart';
import 'package:edziennik/models/subject.dart';
import 'package:edziennik/models/user.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDB extends ChangeNotifier {
  final CollectionReference _userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _classCollectionReference =
      FirebaseFirestore.instance.collection('classes');
  final CollectionReference _subjectsCollectionReference =
      FirebaseFirestore.instance.collection('subjects');
  final CollectionReference _eventsCollectionReference =
      FirebaseFirestore.instance.collection('events');
  final CollectionReference _gradesCollectionReference =
      FirebaseFirestore.instance.collection('degrees');
  final CollectionReference _notesCollectionReference =
      FirebaseFirestore.instance.collection('notes');

  /*
  ##############################################################################
  ######################       NOTES FUNCTIONS      ############################
  ##############################################################################
  */

  Future addNoteToUser(userID, note) async {
    try {
      final snapshot = await _notesCollectionReference.doc(userID).get();
      if (snapshot.exists) {
        await _notesCollectionReference.doc(userID).update({
          'notes': FieldValue.arrayUnion([note])
        });
      } else {
        await _notesCollectionReference.doc(userID).set({'notes': []});
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future deleteNoteFromUser(userID, note) async {
    try {
      await _notesCollectionReference.doc(userID).update({
        'notes': FieldValue.arrayRemove([note])
      });
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getUserNotes(userID) async {
    List<String> notes = [];
    try {
      var all;
      await _notesCollectionReference.doc(userID).get().then((value) => {
            all = value.get('notes'),
            for (var note in all) {notes.add(note)}
          });
      return notes;
    } catch (e) {
      print(e.toString());
      return notes;
    }
  }

  /*
  ##############################################################################
  ######################       DEGREES FUNCTIONS      ############################
  ##############################################################################
  */

  Future getUserDegreesFromSubject(userID, subjectID) async {
    try {
      var grades = await _gradesCollectionReference
          .doc(userID)
          .collection(subjectID)
          .get();
      return grades.docs
          .map((snapshot) => Degree.fromMap(snapshot.data(), snapshot.id))
          .toList();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future addDegree(Degree degree, subjectID) async {
    try {
      final snapshot = await _gradesCollectionReference
          .doc(degree.userID)
          .collection(subjectID)
          .get();
      if (snapshot.docs.isNotEmpty) {
        if (degree.degreeID == '') {
          await _gradesCollectionReference
              .doc(degree.userID)
              .collection(subjectID)
              .add(degree.toMap());
        } else {
          await _gradesCollectionReference
              .doc(degree.userID)
              .collection(subjectID)
              .doc(degree.degreeID)
              .update(degree.toMap());
        }
      } else {
        await _gradesCollectionReference
            .doc(degree.userID)
            .collection(subjectID)
            .add(degree.toMap());
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  /*
  ##############################################################################
  ######################       SUBJECTS FUNCTIONS      #########################
  ##############################################################################
  */

  Future addUserPresence(subjectID, userID, date, wasPresent) async {
    try {
      final snapshot = await _subjectsCollectionReference
          .doc(subjectID)
          .collection(userID)
          .get();
      if (snapshot.docs.length == 0) {
        await _subjectsCollectionReference
            .doc(subjectID)
            .collection(userID)
            .doc('presence')
            .set({date: wasPresent});
      } else {
        await _subjectsCollectionReference
            .doc(subjectID)
            .collection(userID)
            .doc('presence')
            .update({date: wasPresent});
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getUserPresences(subjectID, userID) async {
    Map<String, dynamic> precenses = {};
    try {
      await _subjectsCollectionReference
          .doc(subjectID)
          .collection(userID)
          .doc('presence')
          .get()
          .then((value) => precenses = value.data()!);
      return precenses;
    } catch (e) {
      print(e.toString());
      return precenses;
    }
  }

  Future getTeachersSubjects(String uid) async {
    try {
      List<Subject> subjects = [];
      await _subjectsCollectionReference.get().then(
            (docs) => {
              for (var doc in docs.docs)
                {
                  if (doc.get('leadingTeacherID') == uid)
                    {
                      subjects.add(new Subject(
                          subjectID: doc.id,
                          name: doc.get('name'),
                          leadingTeacherID: doc.get('leadingTeacherID'))),
                    }
                }
            },
          );
      return subjects;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getEventsInClass(classID) async {
    try {
      List<Event> events = [];
      await _eventsCollectionReference.get().then((docs) => {
            for (var doc in docs.docs)
              {
                if (doc.get('classID') == classID)
                  {
                    events.add(Event(
                        date: DateTime.parse(doc.get('date')),
                        type: doc.get('type'),
                        description: doc.get('description'),
                        subject: doc.get('subject'),
                        classID: classID))
                  }
              }
          });
      return events;
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
                subjects.add(new Subject(
                    subjectID: doc.id,
                    name: doc.get('name'),
                    leadingTeacherID: doc.get('leadingTeacherID'))),
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
        await _subjectsCollectionReference
            .doc(subject.subjectID)
            .set(subject.toMap());
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

  /*
  ##############################################################################
  ######################       EVENTS FUNCTIONS      ###########################
  ##############################################################################
  */

  Future addEvent(Event event) async {
    try {
      _eventsCollectionReference.add(event.toMap());
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  /*
  ##############################################################################
  ######################       USERS FUNCTIONS      ############################
  ##############################################################################
  */

  Future getUsers() async {
    try {
      List<User> users = [];
      await _userCollectionReference.get().then(
            (docs) => {
              for (var doc in docs.docs)
                {
                  users.add(new User(
                      userID: doc.get('uid'),
                      name: doc.get('name'),
                      surname: doc.get('surname'),
                      role: doc.get('role'),
                      classID: doc.get('classID'))),
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
                      users.add(new User(
                          userID: doc.id,
                          name: doc.get('name'),
                          surname: doc.get('surname'),
                          role: doc.get('role'),
                          classID: doc.get('classID'))),
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
              user = new User(
                  userID: snapshot['uid'],
                  name: snapshot['name'],
                  surname: snapshot['surname'],
                  role: snapshot['role'],
                  classID: snapshot['classID']),
            },
          );
      return user;
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
                    {
                      users.add(new User(
                          userID: doc.get('uid'),
                          name: doc.get('name'),
                          surname: doc.get('surname'),
                          role: doc.get('role'),
                          classID: doc.get('classID')))
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

  /*
  ##############################################################################
  ######################       CLASS FUNCTIONS      ############################
  ##############################################################################
  */

  Future getClasses() async {
    try {
      List<Class> classes = [];
      await _classCollectionReference.get().then(
            (docs) => {
              for (var doc in docs.docs)
                {
                  classes.add(new Class(
                      classID: doc.id,
                      name: doc.get('name'),
                      supervisingTeacherID: doc.get('supervisingTeacherID'))),
                }
            },
          );
      return classes;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getTeachersClasses(String uid) async {
    try {
      List<Class> classes = [];
      await _classCollectionReference.get().then(
            (docs) => {
              for (var doc in docs.docs)
                {
                  if (doc.get('supervisingTeacherID') == uid)
                    {
                      classes.add(new Class(
                          classID: doc.id,
                          name: doc.get('name'),
                          supervisingTeacherID:
                              doc.get('supervisingTeacherID'))),
                    }
                }
            },
          );
      return classes;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future deleteClassWithID(classID) async {
    try {
      await _classCollectionReference.doc(classID).delete();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getUsersIDsInClass(classID) async {
    try {
      List<String> listOfIDs = [];
      await _classCollectionReference
          .doc(classID)
          .collection('students')
          .get()
          .then(
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

  Future deleteUserFromClass(classID, userID) async {
    try {
      await _classCollectionReference
          .doc(classID)
          .collection('students')
          .doc(userID)
          .delete();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future addUserToClass(classID, userID) async {
    try {
      await _classCollectionReference
          .doc(classID)
          .collection('students')
          .doc(userID)
          .set({});
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future addClass(Class cl) async {
    try {
      if (cl.classID != '') {
        await _classCollectionReference.doc(cl.classID).set(cl.toMap());
      } else {
        await _classCollectionReference.add(cl.toMap());
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future getClassStudents(String classID) async {
    try {
      List<User> users = [];

      List<String> usersIDs = await getUsersIDsInClass(classID);

      for (var userID in usersIDs) {
        User user = await getUserWithID(userID);
        users.add(user);
      }

      return users;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
