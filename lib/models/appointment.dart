import 'package:doctor_app/models/user.dart';
import 'package:flutter/material.dart';

class Appointment {
  int? id;
  String name;
  int age;
  String gender;
  String doctorId;
  String userCreated;
  DateTime? createdDate;
  DateTime time;
  String status;
  String medicalCondition;
  String? result;
  int? rating;
  String? userComment;

  Appointment(
      {required this.id,
      required this.name,
      required this.age,
      required this.gender,
      required this.userCreated,
      required this.doctorId,
      this.createdDate,
      required this.time,
      required this.status,
      required this.medicalCondition,
      this.result,
      this.rating,
      this.userComment});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json['id'] as int,
        name: json['name'] ?? '',
        age: json['age'] as int,
        gender: json['gender'],
        doctorId: json['doctor'],
        userCreated: json['user_created'],
        createdDate: DateTime.parse(json['date_created']),
        time: DateTime.parse(json['time']),
        status: json['status'],
        medicalCondition: json['medical_condition'],
        result: json['result'] ?? '',
        rating: json['rating'] ?? 0,
        userComment: json['user_comment'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'doctor': doctorId,
        'user_created': userCreated,
        'date_created': createdDate,
        'time': time,
        'status': status,
        'medical_condition': medicalCondition,
        'result': result,
        'rating': rating,
        'user_comment': userComment
      };

  List<String> allStatus() {
    return ['pending', 'cancel', 'accepted', 'done'];
  }
}
