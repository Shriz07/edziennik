class User {
  User({
    required this.userID,
    required this.name,
    required this.surname,
    required this.role,
  });

  String userID;
  String name;
  String surname;
  String role;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'surname': surname,
      'role': role,
    };
  }

  User.fromMap(Map snapshot)
      : userID = snapshot['userID'],
        name = snapshot['name'],
        surname = snapshot['surname'],
        role = snapshot['role'];
}
