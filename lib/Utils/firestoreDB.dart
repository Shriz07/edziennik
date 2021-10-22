import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edziennik/models/user.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDB extends ChangeNotifier {
  final CollectionReference _userCollectionReference = FirebaseFirestore.instance.collection('users');

  Future getUsers() async {
    try {
      List<User> users = [];
      await _userCollectionReference.get().then((docs) => {
            for (var doc in docs.docs)
              {
                users.add(new User(userID: doc.get('uid'), name: doc.get('name'), surname: doc.get('surname'), role: doc.get('role'))),
              }
          });
      return users;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
