import 'dart:developer';
import 'package:doctor_app/screens/user/signIn/sign_in.dart';
import 'package:flutter/material.dart';

import '../api/userAPI.dart' as UserAPI;
import '../models/user.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

enum Role { doctor, user }

class _SignUpState extends State<SignUp> {
  Role? _role = Role.doctor;

  final formSignUp = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUp(
      String email, String password, String firstName, String lastName) async {
    if (formSignUp.currentState!.validate()) {
      String roleName = "Doctor";
      switch (_role) {
        case (Role.user):
          roleName = "User";
          break;
        case (Role.doctor):
          roleName = "Doctor";
          break;
        default:
      }
      log('email: $email');
      log('password: $password');
      log('first name: $firstName');
      log('last name: $lastName');
      log('role: $roleName');

      bool success =
          await UserAPI.signUp(email, password, firstName, lastName, roleName);
      if (success) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInWidget()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: formSignUp,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 16),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          return value!.isEmpty || value.length < 4
                              ? "Please enter your email"
                              : null;
                        },
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        validator: (value) {
                          return value!.isEmpty || value.length < 4
                              ? "Please enter your password"
                              : null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: firstNameController,
                        validator: (value) {
                          return value!.isEmpty || value.length < 4
                              ? "Please enter your first name"
                              : null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'First Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextFormField(
                        controller: lastNameController,
                        validator: (value) {
                          return value!.isEmpty || value.length < 4
                              ? "Please enter your last name"
                              : null;
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Last Name',
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(children: [
                          Expanded(
                            child: Row(
                              children: [
                                Radio<Role>(
                                  value: Role.doctor,
                                  groupValue: _role,
                                  onChanged: (Role? value) {
                                    setState(() {
                                      _role = value;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text('Doctor'),
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Radio(
                                  value: Role.user,
                                  groupValue: _role,
                                  onChanged: (Role? value) {
                                    setState(() {
                                      _role = value;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text('Patient'),
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                        ])),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: ElevatedButton(
                          onPressed: () => {
                            signUp(
                                emailController.text,
                                passwordController.text,
                                firstNameController.text,
                                lastNameController.text)
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(
                                50), // fromHeight use double.infinity as width and 40 is the height
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => ({
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInWidget()))
                              }),
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                  children: [
                                    TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
