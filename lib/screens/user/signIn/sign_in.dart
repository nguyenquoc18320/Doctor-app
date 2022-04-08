import 'dart:convert';

import 'package:doctor_app/screens/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/api_helper.dart' as api_helper;
import 'package:doctor_app/models/user.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  //text controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  //vars are used to check showing error
  bool emailError = false;
  bool passwordError = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Image.asset(
                'assets/logo/logo.jpg',
                height: 150,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Sign in to your account',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const <Widget>[
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  hintText: 'Email',
                ),
                style: TextStyle(fontSize: 16),
              ),
              if (emailError) _ErrorWidget(context, 'Invalid email'),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: const <Widget>[
                  Text(
                    'Password',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordTextController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  hintText: 'Password',
                ),
                style: TextStyle(fontSize: 16),
              ),
              if (passwordError) _ErrorWidget(context, 'Invalid password'),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _SignIn(emailTextController.text,
                          passwordTextController.text);
                    });
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot the password?',
                    style: TextStyle(fontSize: 16),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(onPressed: () {}, child: Text('Sign up'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /*
  SignIn function
  */
  void _SignIn(String email, String password) async {
    //check empty field
    emailError = (email.isEmpty == true);
    passwordError = (password.isEmpty == true);

    if (!emailError && !passwordError) {
      //send request
      var response = await http.post(
        Uri.parse(globals.url + "/auth/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}),
      );

      //response
      if (response.statusCode == 200) {
        Map<String, dynamic> res = jsonDecode(response.body);

        //set token
        globals.token = res['data']['access_token'];

        // get user
        response = await api_helper.get('/users/me');
        if (response.statusCode == 200) {
          globals.user = User.fromJson(jsonDecode(response.body)['data']);

          //login successfully
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileWidget()),
          );
        }
      } else {
        print(response.body);
      }
    }
  }

  //show error for email and password
  Widget _ErrorWidget(BuildContext context, String text) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.red[100],
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(children: [
              Icon(
                Icons.error_rounded,
                color: Colors.red,
                size: 20,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
