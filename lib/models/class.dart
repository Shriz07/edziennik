import 'package:edziennik/models/user.dart';

class Class {
  Class({required this.classID, required this.name, required this.supervisingTeacherID});

  String classID;
  String name;
  String supervisingTeacherID;
  late User supervisingTeacher;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'supervisingTeacherID': supervisingTeacherID,
    };
  }

  Class.fromMap(Map snapshot)
      : classID = snapshot['classID'],
        name = snapshot['name'],
        supervisingTeacherID = snapshot['supervisingTeacher'],
        supervisingTeacher = snapshot['supervisingTeacher'];
}
