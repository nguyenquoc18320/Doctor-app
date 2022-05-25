import 'package:doctor_app/screens/user/profile.dart';
import 'package:doctor_app/screens/user/signIn/sign_in.dart';
import 'package:doctor_app/widgets/user/bottomNavigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: globals.user!.avataId != null
                    ? Image.network(
                        globals.url + "/assets/" + globals.user!.avataId!,
                        headers: {"authorization": "Bearer " + globals.token},
                        height: 124,
                        width: 124,
                      )
                    : Image.asset(
                        'assets/logo/small_logo.png',
                        width: 124,
                        height: 124,
                      )),
            Center(
              child: Text(
                globals.user!.email,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  child: GestureDetector(
                    child: Center(
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFf2563EB),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '|',
                    style: TextStyle(color: Color(0xFF8F8F8F)),
                  ),
                ),
                Container(
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileWidget()));
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.create_rounded, color: Color(0xFF2563EB)),
                          Text(
                            'Update info',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFf2563EB),
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                globals.token = '';
                                globals.refresh_token = '';
                                globals.user = null;
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => SignInWidget()),
                                    (Route<dynamic> route) => false);
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Logout',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            info()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(currentIndex: 3),
    );
  }

  Widget info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Information',
          style: TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Container(
              width: 96,
              child: Text(
                'Email:',
                style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
              ),
            ),
            Text(
              globals.user!.email,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: 96,
              child: Text(
                'Password:',
                style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
              ),
            ),
            Text(
              '******',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: 96,
              child: Text(
                'Fullname:',
                style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
              ),
            ),
            Text(
              globals.user!.firstName + ' ' + globals.user!.lastName,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Container(
              width: 96,
              child: Text(
                'Age:',
                style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
              ),
            ),
            Text(
              (DateTime.now().year - globals.user!.birthdate!.year).toString(),
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
