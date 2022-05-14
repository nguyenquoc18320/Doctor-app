import 'package:doctor_app/screens/user/signIn/sign_in.dart';
import 'package:doctor_app/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doctor_app/globals.dart' as globals;

import '../api/userAPI.dart' as UserAPI;
import '../services/auth.dart';
import '../services/database.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

enum Role { doctor, user }

class _SignUpState extends State<SignUp> {
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethod dbMethod = new DatabaseMethod();
  Role? _role = Role.doctor;

  final formSignUp = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbMethod.retrieveChatRooms().then((users) => {});
  }

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

      String avatarId = globals.avatar_placeholder_id;

      // print("Avatar Id: " + avatarId);

      bool success = await UserAPI.signUp(
          email, password, firstName, lastName, roleName, avatarId);

      if (success) {
        String name = "$firstName $lastName";
        Map<String, String> userInfoMap = {
          'name': name,
          'email': email,
          'role': roleName,
          'avatar_url': globals.avatar_placeholder_url,
        };
        authMethod.signUpWithEmailAndPassword(email, password).then((uid) {
          dbMethod.uploadUserInfo(uid, userInfoMap).then((newUser) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SignInWidget()));
          });
        });
      }
    }
  }

  String? emailValidator(String? value) {
    return value!.isEmpty || value.length < 4
        ? "Please enter your email"
        : null;
  }

  String? passwordValidator(String? value) {
    return value!.isEmpty || value.length < 4
        ? "Please enter your password"
        : null;
  }

  String? firstNameValidator(String? value) {
    return value!.isEmpty || value.length < 4
        ? "Please enter your firstname"
        : null;
  }

  String? lastNameValidator(String? value) {
    return value!.isEmpty || value.length < 4
        ? "Please enter your lastname"
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: formSignUp,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello.',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      'Create a new account',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    MyTextFormField(
                      title: 'Email',
                      textController: emailController,
                      validator: emailValidator,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    MyTextFormField(
                      title: 'Password',
                      isPassword: true,
                      textController: passwordController,
                      validator: passwordValidator,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    MyTextFormField(
                      title: 'Firstname',
                      textController: firstNameController,
                      validator: firstNameValidator,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    MyTextFormField(
                      title: 'Lastname',
                      textController: lastNameController,
                      validator: lastNameValidator,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(children: [
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
                    ]),
                    SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        signUp(emailController.text, passwordController.text,
                            firstNameController.text, lastNameController.text)
                      },
                      child: Text(
                        'Sign Up',
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        minimumSize: Size.fromHeight(56),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
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
                            text: TextSpan(
                              text: 'Already have an account?  ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                              children: [
                                TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
