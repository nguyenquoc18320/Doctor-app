import 'package:doctor_app/screens/user/signIn/sign_in.dart';
import 'package:doctor_app/widgets/base/BtnPrimary.dart';
import 'package:doctor_app/widgets/base/TextFieldPrimary.dart';
import 'package:doctor_app/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  Role? _role = Role.user;

  final formSignUp = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbMethod.retrieveChatRooms().then((users) => {});
  }

  void signUp(String email, String password, String firstName) async {
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

      bool success =
          await UserAPI.signUp(email, password, firstName, roleName, avatarId);

      if (success) {
        Map<String, String> userInfoMap = {
          'name': firstName,
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
    return value!.isEmpty || value.length < 4 ? "Please enter your name" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffEEEAFB),
        elevation: 0.0,
        foregroundColor: Color(0xFF4702A2),
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.chevronLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: formSignUp,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/illustration-2.png',
                      height: 200,
                    ),
                    Text(
                      'Welcome.',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      'Meet doctors with a simple touch',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldPrimary(
                      title: 'Email',
                      textController: emailController,
                      validator: emailValidator,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFieldPrimary(
                      title: 'Password',
                      isPassword: true,
                      textController: passwordController,
                      validator: passwordValidator,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFieldPrimary(
                      title: 'Fullname',
                      textController: firstNameController,
                      validator: firstNameValidator,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(children: [
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
                              child: Text(
                                'Doctor',
                              ),
                            )
                          ],
                        ),
                        flex: 1,
                      ),
                    ]),
                    SizedBox(
                      height: 16,
                    ),
                    BtnPrimary(
                      title: 'Sign Up',
                      cb_press: () => {
                        signUp(emailController.text, passwordController.text,
                            firstNameController.text)
                      },
                    ),
                    SizedBox(
                      height: 10,
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
                                  color: Colors.black,
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
