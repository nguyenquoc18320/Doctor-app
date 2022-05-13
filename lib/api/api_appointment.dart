import 'dart:convert';

import 'package:doctor_app/models/appointment.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/api_helper.dart' as API_helper;
import 'package:intl/intl.dart';

Future<Appointment?> createAppointment(Appointment appointment) async {
  String url = '/items/Appointments';

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
    return null;
  }
}

/*
get appointment by id
*/
Future<Appointment?> getAppointmentById(int id) async {
  String url = '/items/Appointments/' + id.toString();

  http.Response response = await API_helper.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    Appointment appointment = Appointment.fromJson(json['data']);

    return appointment;
  }
  return null;
}

/*
get upcomming appointments with time sorted ascending
*/
Future<List<Appointment>> getUserUpcommingAppointments(
    String userid, int pageNumber, DateTime day) async {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String url = '/items/Appointments?filter={"user_created" : { "_eq" : "' +
      userid +
      '"}, "status": { "_in" : [ "pending", "accepted", "done"]}, "time" : {"_between": ["' +
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
Future<List<Appointment>> getUserPastAppointments(
    String userid, int pageNumber) async {
  String url = '/items/Appointments?filter={"user_created" : { "_eq" : "' +
      userid +
      '"}, "status": { "_nin" : [ "cancel"]}, "time" : {"_lt": "' +
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
get past appointments with time sorted ascending
*/
Future<List<Appointment>> getUserCancelAppointments(
    String userid, int pageNumber) async {
  String url = '/items/Appointments?filter={"user_created" : { "_eq" : "' +
      userid +
      '"}, "status": { "_eq" : "cancel"}}&sort=-time&page=' +
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
      '"}, "status": { "_nin" : [ "cancel", "done"]}, "time" : {"_between": ["' +
      formatter.format(date) +
      '", "' +
      formatter.format(date.add(Duration(days: 1))) +
      '"]}}';

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

Future<List<Appointment>> getAppointmentOfDoctorByTime(
    String doctorid, DateTime date) async {
  String url = '/items/Appointments?filter={"doctor" : { "_eq" : "' +
      doctorid +
      '"}, "time" : {"_eq": "' +
      date.toIso8601String() +
      '"}}';

  http.Response response = await API_helper.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    List<Appointment> appointments = List<Appointment>.from(
        json['data'].map((data) => Appointment.fromJson(data)).toList());
    return appointments;
  } else {
    return [];
  }
}

/*Cancel appointment*/
Future<bool> cancelAppointment(int appointmentid) async {
  //get appointment to check time
  Appointment? appointment = await getAppointmentById(appointmentid);

  if (appointment == null) {
    return false;
  }

  //check time
  DateTime minusAppointmentTime = appointment.time.subtract(Duration(days: 1));
  if (DateTime.now().compareTo(minusAppointmentTime) > 0) {
    //not over 24h
    return false;
  }

  //cancel
  String url = '/items/Appointments/' + appointmentid.toString();

  Map<String, String> jsonBody = {"status": "cancel"};

  http.Response response = await API_helper.patch(url, jsonBody);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

////////////////////for doctor//////////////////////////
/*
get upcomming appointments of doctor with time sorted ascending
*/
Future<List<Appointment>> getDoctorUpcommingAppointments(
    String doctorid, int pageNumber, DateTime day) async {
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String url = '/items/Appointments?filter={"doctor" : { "_eq" : "' +
      doctorid +
      '"}, "status": { "_in" : [ "pending", "accepted", "done"]}, "time" : {"_between": ["' +
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

Future<List<Appointment>> getDoctorPastAppointments(
    String doctorid, int pageNumber) async {
  String url = '/items/Appointments?filter={"doctor" : { "_eq" : "' +
      doctorid +
      '"}, "status": { "_nin" : [ "cancel"]}, "time" : {"_lt": "' +
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

Future<List<Appointment>> getDoctorCancelAppointments(
    String doctorid, int pageNumber) async {
  String url = '/items/Appointments?filter={"doctor" : { "_eq" : "' +
      doctorid +
      '"}, "status": { "_eq" : "cancel"}}&sort=-time&page=' +
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
get appointments of doctor in period 
*/
Future<List<Appointment>> getAppointmentsByDoctorInPeriodAndPendingOrAccepted(
    String doctorid, DateTime start, DateTime end) async {
  String url = '/items/Appointments?filter={"doctor" : { "_eq" : "' +
      doctorid +
      '"}, "status": { "_in" : ["pending", "accepted"]}, "time" : {"_between": [" ' +
      DateFormat('yyyy-MM-dd HH:mm:ss').format(start) +
      '", "' +
      DateFormat('yyyy-MM-dd HH:mm:ss').format(end) +
      '"]}}&sort=time';

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


// /*
// get appointments in 2 period (for check editting working time)
// */
// Future<List<Appointment>> getAppointmentsIn2Period
