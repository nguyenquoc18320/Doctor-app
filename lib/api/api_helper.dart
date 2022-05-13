import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;
import 'package:http_parser/http_parser.dart';

Future<http.Response> get(String url) async {
  var response = await http.get(
    Uri.parse(globals.url + url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + globals.token,
    },
  );

  if (response.statusCode == 403) {
    refreshToken();
    response = await http.get(
      Uri.parse(globals.url + url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + globals.token,
      },
    );
  }

  return response;
}

Future<http.Response> patch(String url, Map<String, String> json) async {
  var response = await http.patch(
    Uri.parse(globals.url + url),
    body: jsonEncode(json),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + globals.token,
    },
  );

  print(jsonEncode(json));

  if (response.statusCode == 403) {
    refreshToken();
    response = await http.patch(
      Uri.parse(globals.url + url),
      body: jsonEncode(json),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + globals.token,
      },
    );
  }
  return response;
}

Future<http.Response> post(String url, Map<String, dynamic> json) async {
  var response = await http.post(
    Uri.parse(globals.url + url),
    body: jsonEncode(json),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + globals.token,
    },
  );

  if (response.statusCode == 403) {
    refreshToken();
    response = await http.post(
      Uri.parse(globals.url + url),
      body: jsonEncode(json),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + globals.token,
      },
    );
  }
  return response;
}

Future<http.Response> delete(String url) async {
  var response = await http.delete(
    Uri.parse(globals.url + url),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + globals.token,
    },
  );

  if (response.statusCode == 403) {
    refreshToken();
    response = await http.post(
      Uri.parse(globals.url + url),
      body: jsonEncode(json),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + globals.token,
      },
    );
  }
  return response;
}

Future<String> uploadFile(String path) async {
  var postUri = Uri.parse(globals.url + '/files');

  // var bytes = (await rootBundle.load('images/photo1.png')).buffer.asUint8List();
  var request = http.MultipartRequest("POST", postUri)
    ..headers.addAll({
      'Authorization': 'Bearer ' + globals.token,
    })
    ..files.add(http.MultipartFile.fromBytes(
        'file', await File.fromUri(Uri.parse(path)).readAsBytesSync(),
        filename: path.split('/').last));

  // request.send().then((response) {
  //   if (response.statusCode == 200) print("Uploaded!");
  // });
  // print('path ' + path);
  // var uri = Uri.parse(globals.url + '/files');
  // var request = http.MultipartRequest('POST', uri)
  //   // ..fields['user'] = 'nweiz@google.com'
  //   ..headers.addAll({
  //     'Authorization': 'Bearer ' + globals.token,
  //   })
  //   ..files.add(await http.MultipartFile.fromPath(
  //     'file',
  //      await File.fromUri(Uri.parse(path)).readAsBytes(),
  //      contentType: MediaType('application', 'x-tar')
  //   ));
  var streamedResponse = await request.send();
  if (streamedResponse.statusCode == 200) {
    final response = await http.Response.fromStream(streamedResponse);
    var json = jsonDecode(response.body);
    return json['data']['id'];
  } else
    return '';
}

/*
refresh 
 */
refreshToken() async {
  var response = await http.post(
    Uri.parse(globals.url + '/auth/refresh'),
    body: jsonEncode({"refresh_token": "${globals.refresh_token}"}),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> res = jsonDecode(response.body);

    //set token
    globals.token = res['data']['access_token'];
    globals.refresh_token = res['data']['refresh_token'];
  }
}
