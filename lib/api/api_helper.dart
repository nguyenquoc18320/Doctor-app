import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;

Future<http.Response> get(String url) async {
  var response = await http.get(
    Uri.parse(globals.url + url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + globals.token,
    },
  );

  return response;
}

Future<http.Response> patch(String url, Map<String, String> json) async {
  return await http.patch(
    Uri.parse(globals.url + url),
    body: jsonEncode(json),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + globals.token,
    },
  );
}
