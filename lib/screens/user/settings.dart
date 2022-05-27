import 'package:doctor_app/screens/user/profile.dart';
import 'package:doctor_app/screens/user/signIn/sign_in.dart';
import 'package:doctor_app/widgets/base/BtnPrimary.dart';
import 'package:doctor_app/widgets/user/bottomNavigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 96,
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
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileWidget()));
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.create_rounded, color: Color(0xFF4702A2)),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Update info',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFf4702A2),
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  globals.user!.email,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              BtnPrimary(
                title: 'Logout',
                cb_press: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              'Confirmation',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xff82CABE)),
                                ),
                              ),
                            ],
                          ));
                },
              ),
              SizedBox(
                height: 32,
              ),
              info()
            ],
          ),
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
              color: Color(0xFF4702A2),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Container(
              width: 96,
              child: Text(
                'Email:',
              ),
            ),
            Text(globals.user!.email),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Container(
              width: 96,
              child: Text(
                'Password:',
              ),
            ),
            Text(
              '* * * * * *',
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Container(
              width: 96,
              child: Text(
                'Fullname:',
              ),
            ),
            Text(
              globals.user!.firstName + ' ' + globals.user!.lastName,
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Container(
              width: 96,
              child: Text(
                'Age:',
              ),
            ),
            Text(
              globals.user!.birthdate != null
                  ? (DateTime.now().year - globals.user!.birthdate!.year)
                      .toString()
                  : '',
            ),
          ],
        ),
      ],
    );
  }
}
