import 'dart:convert';
import 'dart:ffi';

import 'package:doctor_app/models/specialist.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/api/api_helper.dart' as api_helper;

import '../models/user.dart';

//get role id of doctor
Future<String> getDoctorRoleId() async {
  http.Response response = await api_helper.get('/roles');

  try {
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> roles = json['data'];

      for (var role in roles) {
        if (role['name'].toString().toLowerCase() == 'doctor')
          return role['id'].toString();
      }
    }
  } catch (ex) {
    return '';
  }
  return '';
}

//get doctors randomly
Future<List<User>> getDoctorList(int limit) async {
  //get doctor role id
  String id = await getDoctorRoleId();

  String url = '/users?filter[role]=' + id + '&limit=' + limit.toString();

  http.Response response = await api_helper.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);

    List<User> doctors = List<User>.from(
        json['data'].map((data) => User.fromJson(data)).toList());
    return doctors;
  } else {
    return [];
  }
}

//get doctors by specialist
Future<List<User>> getDoctorsBySpecialist(Specialist specialist,
    [String doctorName = '']) async {
  //get doctor role id
  String id = await getDoctorRoleId();

  String url =
      '/users?filter[role]=' + id + '&filter[title]=' + specialist.name;

  if (doctorName.isNotEmpty) {
    url += '&filter[first_name]=' + doctorName;
  }

  http.Response response = await api_helper.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    List<User> doctors = List<User>.from(
        json['data'].map((data) => User.fromJson(data)).toList());

    return doctors;
  } else {
    return [];
  }
}

/*
get doctor by id
*/
Future<User> getUserById(String id) async {
  String url = "/users/" + id;

  http.Response response = await api_helper.get(url);
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    User user = User.fromJson(json['data']);

    return user;
  } else {
    return User(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        gender: '',
        location: '',
        birthdate: null,
        avataId: '',
        description: '');
  }
}


/*
get doctor's working time
*/
// Future