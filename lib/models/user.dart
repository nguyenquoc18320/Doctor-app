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
  String? avataId;
  String? role; //user or doctor
  String? title; //if being doctor, title is doctor's specilist
  String? description;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.password,
      required this.gender,
      required this.location,
      required this.birthdate,
      this.avataId,
      this.role,
      this.title,
      this.description});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'],
        password: json['password'],
        avataId: json['avatar'] ?? '',
        location: json['location'] ?? '',
        birthdate: json['birthdate'] == null
            ? null
            : DateTime.parse(json['birthdate'].toString()),
        gender: json['gender'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '');
  }

  List<String> specialist = [
    'Dental Specialist',
    'Eye Specialist',
    'Cardio Specialist',
    'Pediatric'
  ];
}
