import 'package:doctor_app/screens/user/chat_room.dart';
import 'package:doctor_app/screens/user/home.dart';
import 'package:doctor_app/screens/user/myAppointment.dart';
import 'package:doctor_app/screens/user/profile.dart';
import 'package:doctor_app/screens/user/settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationBarCustom extends StatelessWidget {
  final int currentIndex;
  const BottomNavigationBarCustom({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.heart),
          label: 'Favorit',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.calendarDay),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.message),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeWidget()));
        } else if (index == 2) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => myAppointmentScreen()));
        } else if (index == 3) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChatRoom()));
        } else if (index == 4) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SettingScreen()));
        }
      },
    );
  }
}
