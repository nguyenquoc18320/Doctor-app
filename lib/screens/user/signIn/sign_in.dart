import 'dart:convert';

import 'package:doctor_app/screens/doctor/appointments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/screens/doctor/home.dart';
import 'package:doctor_app/screens/sign_up.dart';
import 'package:doctor_app/screens/user/home.dart';
import 'package:doctor_app/screens/user/profile.dart';
import 'package:doctor_app/widgets/base/BtnPrimary.dart';
import 'package:doctor_app/widgets/base/TextFieldPrimary.dart';
import 'package:doctor_app/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/api_helper.dart' as api_helper;
import 'package:doctor_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth.dart';
import '../../../services/database.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

enum Role { doctor, user }

class _SignInWidgetState extends State<SignInWidget> {
  //text controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  Role? roleController = Role.user;

  //vars are used to check showing error
  bool emailError = false;
  bool passwordError = false;

  bool openLoading = false;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (emailError == true && openLoading == true) {
        print('close jjj');
        Navigator.of(context, rootNavigator: true).pop();
        openLoading = false;
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEEEAFB),
        elevation: 0.0,
        foregroundColor: Color(0xFF4702A2),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/illustration-1.png',
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   'Welcome to ',
                    //   style: TextStyle(
                    //     fontSize: 28,
                    //     color: Colors.black,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Text(
                      'Welcome to DoctorCare',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                Text(
                  'Meet doctors with a simple touch',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldPrimary(
                  title: 'Email',
                  textController: emailTextController,
                ),
                if (emailError) _ErrorWidget(context, 'Incorrect email'),
                const SizedBox(
                  height: 8,
                ),
                TextFieldPrimary(
                  title: 'Password',
                  textController: passwordTextController,
                  isPassword: true,
                ),
                SizedBox(
                  height: 8,
                ),
                if (passwordError) _ErrorWidget(context, 'Incorrect password'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(children: [
                        Radio<Role>(
                            value: Role.user,
                            groupValue: roleController,
                            onChanged: (Role? value) => {
                                  setState(() => {roleController = value})
                                }),
                        Expanded(
                          child: Text('Patient'),
                        )
                      ]),
                    ),
                    Expanded(
                      child: Row(children: [
                        Radio<Role>(
                            value: Role.doctor,
                            groupValue: roleController,
                            onChanged: (Role? value) => {
                                  setState(
                                    () => {roleController = value},
                                  )
                                }),
                        Expanded(
                          child: Text('Doctor'),
                        )
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BtnPrimary(
                    title: 'Log In',
                    cb_press: () {
                      setState(() {
                        Future.delayed(Duration.zero, () async {
                          if (openLoading == false) {
                            print('open');
                            openLoading = true;
                            loading(context);
                          }
                        });

                        _SignIn(emailTextController.text,
                            passwordTextController.text, context);
                      });
                    }),
                SizedBox(
                  height: 10,
                ),
                // TextButton(
                //     onPressed: () => ({
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => ForgotPassword()))
                //         }),
                //     child: const Text(
                //       'Forgot the password?',
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, color: Colors.black),
                //     )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => ({
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()))
                      }),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account?  ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                          children: [
                            TextSpan(
                                text: 'Sign up now',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
  SignIn function
  */
  void _SignIn(String email, String password, BuildContext context) async {
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
        print('sign in');

        //set token
        globals.token = res['data']['access_token'];
        globals.refresh_token = res['data']['refresh_token'];

        // get user
        response = await api_helper.get('/users/me');
        if (response.statusCode == 200) {
          var userJson = jsonDecode(response.body)['data'];

          //get role
          response = await api_helper.get("/roles/" + userJson['role']);

          if (response.statusCode == 200) {
            var roleJson = jsonDecode(response.body)['data'];
            String roleName = roleJson['name'];

            //check role
            if (roleController.toString().split('.').last.toLowerCase() ==
                    'doctor' &&
                roleName.toLowerCase() ==
                    roleController.toString().split('.').last.toLowerCase()) {
              //as doctor
              globals.user = User.fromJson(userJson);

              globals.user!.role = 'doctor';

              /* 
                TODO - login firebase 
              */
              AuthMethod authMethod = new AuthMethod();
              DatabaseMethod dbMethod = new DatabaseMethod();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("email", email);

              QuerySnapshot userByEmail = await dbMethod.getUserByEmail(email);

              print('${userByEmail.docs[0]['name']}');
              prefs.setString("id", userByEmail.docs[0].id);
              prefs.setString("name", userByEmail.docs[0]['name']);

              authMethod
                  .signInWithEmailAndPassword(email, password)
                  .then((value) {
                if (value != null) {
                  prefs.setBool("isLoggedIn", true);

                  if (openLoading == true) {
                    openLoading = false;
                    print('close');
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  //login successfully
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeDoctorScreen()),
                  );
                }
              });
            } else if (roleController
                        .toString()
                        .split('.')
                        .last
                        .toLowerCase() ==
                    'user' &&
                roleName.toLowerCase() ==
                    roleController.toString().split('.').last.toLowerCase()) {
              //as patient
              globals.user = User.fromJson(userJson);

              globals.user!.role = 'user';

              /* 
                TODO - login firebase 
              */
              AuthMethod authMethod = new AuthMethod();
              DatabaseMethod dbMethod = new DatabaseMethod();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("email", email);

              QuerySnapshot userByEmail = await dbMethod.getUserByEmail(email);

              print('${userByEmail.docs[0]['name']}');
              prefs.setString("id", userByEmail.docs[0].id);
              prefs.setString("name", userByEmail.docs[0]['name']);

              authMethod
                  .signInWithEmailAndPassword(email, password)
                  .then((value) {
                if (value != null) {
                  prefs.setBool("isLoggedIn", true);

                  if (openLoading == true) {
                    openLoading = false;
                    print('close');
                    Navigator.of(context, rootNavigator: true).pop();
                  }

                  //login successfully
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeWidget()),
                  );
                }
              });
            } else {
              //incorrect
              globals.refresh_token = '';
              globals.token = '';
              emailError = true;
              passwordError = true;
            }
          } else {
            globals.refresh_token = '';
            globals.token = '';
            emailError = true;
            passwordError = true;
          }
        }
      } else {
        emailError = true;
        passwordError = true;
      }
    }
    // print('continue');
    setState(() {});
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
