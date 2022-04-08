class User {
  //properties
  String? id;
  String firstName;
  String lastName;
  String email;
  String? password;
  String gender;
  String location;
  DateTime? birthdate;
  String? avata;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.password,
      required this.gender,
      required this.location,
      required this.birthdate,
      this.avata});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        password: json['password'],
        avata: json['avata'],
        location: json['location'] == null ? '' : json['location'],
        birthdate: json['birthdate'] == null
            ? null
            : DateTime.parse(json['birthdate'].toString()),
        gender: json['gender'] == null ? '' : json['gender']);
  }
}
