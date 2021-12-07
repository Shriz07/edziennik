class User {
  User({required this.userID, required this.name, required this.surname, required this.role, required this.classID});

  String userID;
  String name;
  String surname;
  String role;
  String classID;

  Map<String, dynamic> toMap() {
    return {
      'uid': userID,
      'name': name,
      'surname': surname,
      'role': role,
      'classID': classID,
    };
  }

  User.fromMap(Map snapshot)
      : userID = snapshot['uid'],
        name = snapshot['name'],
        surname = snapshot['surname'],
        role = snapshot['role'],
        classID = snapshot['classID'];
}
