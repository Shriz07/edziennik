import 'package:edziennik/models/user.dart';

class Subject {
  Subject({
    required this.subjectID,
    required this.name,
    required this.leadingTeacherID,
  });

  String subjectID;
  String name;
  String leadingTeacherID;
  late User leadingTeacher;
}
