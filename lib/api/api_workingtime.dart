import 'dart:convert';
import 'dart:io';

import 'package:doctor_app/models/workingtime.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;
import 'package:http_parser/http_parser.dart';
import 'package:doctor_app/api/api_helper.dart' as api_helper;
import 'package:intl/intl.dart';

//get working time of doctor
Future<List<WorkingTime>> getWorkingTimeByDoctorID(String doctorID) async {
  String url = '/items/Work_time?filter[user_created]=' + doctorID;

  http.Response response = await api_helper.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    List<WorkingTime> workingTimes = List<WorkingTime>.from(
        json['data'].map((data) => WorkingTime.fromJson(data)).toList());
    return workingTimes;
  } else {
    return [];
  }
}

//create wk
Future<WorkingTime?> createWorkingTime(WorkingTime wk) async {
  String url = '/items/Work_time';

  // print(jsonMap);
  Map<String, dynamic> jsonMap = {
    "day": wk.day,
    "time_from": DateFormat('HH:mm:ss').format(wk.startTime),
    "time_to": DateFormat("HH:mm:ss").format(wk.endTime)
  };

  http.Response response = await api_helper.post(url, jsonMap);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    WorkingTime workingTime = WorkingTime.fromJson(json['data']);

    return workingTime;
  } else {
    return null;
  }
}

Future<WorkingTime?> updateWorkingTime(WorkingTime wk) async {
  String url = '/items/Work_time/' + wk.id.toString();

  Map<String, String> jsonMap = {
    "day": wk.day,
    "time_from": DateFormat('HH:mm:ss').format(wk.startTime),
    "time_to": DateFormat("HH:mm:ss").format(wk.endTime)
  };

  http.Response response = await api_helper.patch(url, jsonMap);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    WorkingTime workingTime = WorkingTime.fromJson(json['data']);

    return workingTime;
  } else {
    return null;
  }
}

Future<bool> deleteWorkingTime(WorkingTime wk) async {
  String url = '/items/Work_time/' + wk.id.toString();

  http.Response response = await api_helper.delete(url);

  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}
