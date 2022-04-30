import 'dart:convert';
import 'dart:io';

import 'package:doctor_app/models/workingtime.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;
import 'package:http_parser/http_parser.dart';
import 'package:doctor_app/api/api_helper.dart' as api_helper;

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
