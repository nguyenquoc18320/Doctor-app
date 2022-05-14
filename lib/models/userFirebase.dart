import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebase {
  final String? id;
  String name;
  String email;
  String role;
  String avatar_url;

  UserFirebase(
      {this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.avatar_url});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'avatar_url': avatar_url,
    };
  }

  UserFirebase.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        email = doc.data()!["email"],
        role = doc.data()!["role"],
        avatar_url = doc.data()!["avatar_url"];
}
