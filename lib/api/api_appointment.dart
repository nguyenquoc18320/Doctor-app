import 'dart:convert';

import 'package:doctor_app/models/appointment.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/api_helper.dart' as API_helper;
import 'package:intl/intl.dart';

Future<Appointment?> createAppointment(Appointment appointment) async {
  String url = '/items/Appointments';

  // Map<String, dynamic> jsonMap = appointment.toJson();

  // jsonMap = jsonMap..remove('id');
  // jsonMap = jsonMap..remove('result');
  // jsonMap = jsonMap..remove('user_created');
  // jsonMap = jsonMap..remove('date_created');

  // print(jsonMap);
  Map<String, dynamic> jsonMap = {
    "status": appointment.status,
    "doctor": appointment.doctorId,
    "time": appointment.time.toIso8601String(),
    "medical_condition": appointment.medicalCondition,
    "name": appointment.name,
    "age": appointment.age,
    "gender": appointment.gender
  };
  http.Response response = await API_helper.post(url, jsonMap);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    Appointment appointment = Appointment.fromJson(json['data']);

    return appointment;
  } else {
    print('CREATE appointment fail');
    print(response.body);
    return null;
  }
}

/*
get upcomming appointments with time sorted ascending
*/
Future<List<Appointment>> getUpcommingAppointments(
    String userid, int pageNumber, DateTime day) async {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String url = '/items/Appointments?filter={"user_created" : { "_eq" : "' +
      userid +
      '"}, "status": { "_in" : [ "pending", "accepted"]}, "time" : {"_between": ["' +
      formatter.format(day) +
      '", "' +
      formatter.format(day.add(Duration(days: 1))) +
      '"]}}&sort=time&page=' +
      pageNumber.toString();

  http.Response response = await API_helper.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    //convert into list
    List<Appointment> appointments = List<Appointment>.from(
        json['data'].map((data) => Appointment.fromJson(data)).toList());
    return appointments;
  } else {
    return [];
  }
}

/*
get past appointments with time sorted ascending
*/
Future<List<Appointment>> getPastAppointments(
    String userid, int pageNumber) async {
  String url = '/items/Appointments?filter={"user_created" : { "_eq" : "' +
      userid +
      '"}, "time" : {"_lt": "' +
      r'$NOW"}}&sort=-time&page=' +
      pageNumber.toString();

  http.Response response = await API_helper.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    //convert into list
    List<Appointment> appointments = List<Appointment>.from(
        json['data'].map((data) => Appointment.fromJson(data)).toList());

    return appointments;
  } else {
    return [];
  }
}

/*
get appointments of doctor in a day
*/
Future<List<Appointment>> getAppointmentsOfDoctorInDay(
    String doctorid, DateTime date) async {
  date = DateTime(date.year, date.month, date.day);

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String url = '/items/Appointments?filter={"doctor" : { "_eq" : "' +
      doctorid +
      '"}, "status": { "_nin" : [ "cancel"]}, "time" : {"_between": ["' +
      formatter.format(date) +
      '", "' +
      formatter.format(date.add(Duration(days: 1))) +
      '"]}}';
  print('URL: ' + url);

  http.Response response = await API_helper.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    //convert into list
    List<Appointment> appointments = List<Appointment>.from(
        json['data'].map((data) => Appointment.fromJson(data)).toList());
    return appointments;
  } else {
    return [];
  }
}
