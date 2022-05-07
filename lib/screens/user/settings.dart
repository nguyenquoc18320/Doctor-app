import 'package:doctor_app/screens/user/profile.dart';
import 'package:doctor_app/screens/user/signIn/sign_in.dart';
import 'package:doctor_app/widgets/user/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/globals.dart' as globals;

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          padding:
              const EdgeInsets.only(right: 10, left: 10, bottom: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Image.asset('assets/logo/small_logo.jpg'),
                Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )
              ]),
              Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlue.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileWidget()));
                    },
                    icon: Icon(
                      Icons.create_sharp,
                      color: Colors.blue,
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: globals.user!.avataId != null
                        ? Image.network(
                            globals.url + "/assets/" + globals.user!.avataId!,
                            headers: {
                              "authorization": "Bearer " + globals.token
                            },
                            height: 100,
                            width: 100,
                          )
                        : Image.asset(
                            'assets/logo/small_logo.png',
                            width: 100,
                            height: 100,
                          )),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        globals.user!.firstName + ' ' + globals.user!.lastName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        globals.user!.email,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                )
              ],
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
                  children: [
                    Icon(
                      Icons.logout,
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
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(currentIndex: 4),
    );
  }
}
