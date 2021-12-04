import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Degree {
  Degree({required this.userID, required this.grade, required this.date, required this.comment, required this.weight});

  String userID;
  String grade;
  DateTime date;
  String comment;
  String weight;
  String degreeID = '';

  Degree.fromMap(Map snapshot, String id)
      : userID = snapshot['userID'],
        grade = snapshot['grade'],
        date = snapshot['date'].toDate(),
        comment = snapshot['comment'],
        weight = snapshot['weight'],
        degreeID = id;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'grade': grade,
      'date': Timestamp.fromDate(date),
      'comment': comment,
      'weight': weight,
    };
  }
}
