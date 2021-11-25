class Event {
  Event({required this.date, required this.type, required this.description, required this.subject, required this.classID});

  DateTime date;
  String type;
  String description;
  String subject;
  String classID;

  Map<String, dynamic> toMap() {
    return {
      'date': date.toString(),
      'subject': subject,
      'type': type,
      'description': description,
      'classID': classID,
    };
  }
}
