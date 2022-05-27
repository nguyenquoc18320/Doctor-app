import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../models/user.dart';
import '../models/role.dart';

import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/api_helper.dart' as api_helper;

const headers = {
  'Content-Type': 'application/json; charset=UTF-8',
};

Future<bool> signUp(String email, String password, String firstName,
    String role, String avatar_id) async {
  const endPoint = '/users';

  final url = globals.url + endPoint;

  List<Role> roles = await getRole();

  log('Roles: $roles');

  Role? roleObject;

  for (var item in roles) {
    if (item.name == role) {
      roleObject = item;
    }
  }

  log('Role Object: $roleObject');

  String? roleId = roleObject!.id;

  log('Role id: $roleId');

  // var roleObj = Role();
  // roleObj = roleObject.toString();
  // log('Roles: $roles');
  // log('Role Obj: $roleObj');
  // log('Role id: $roleId');

  final res = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(<String, String>{
      'first_name': firstName,
      'email': email,
      'password': password,
      'role': roleId ?? '',
      'avatar': avatar_id,
    }),
  );

  // User? user;

  log(res.statusCode.toString());
  log(res.body);

  if (res.statusCode == 204) {
    // Map<String, dynamic> json = jsonDecode(res.body);
    // user = User.fromJson(json);
    return true;
  }

  return false;
}

Future getRole() async {
  const endPoint = '/roles?fields=id,name';

  final url = globals.url + endPoint;

  final res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(res.body);
    List<Role> roles = List<Role>.from(
        json['data'].map((data) => Role.fromJson(data)).toList());

    return roles;
  } else {
    return [];
  }
}

/*
get user by id
*/
Future<User?> getUserById(String id) async {
  String url = "/users/" + id;

  http.Response response = await api_helper.get(url);
  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    User user = User.fromJson(json['data']);

    return user;
  } else {
    return null;
  }
}
