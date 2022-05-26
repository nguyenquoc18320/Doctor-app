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
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xFFEFF6FF),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.house,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.calendarDay,
              size: 24,
            ),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.commentDots,
              size: 24,
            ),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.user,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Color(0xFF3B82F6),
        unselectedItemColor: Color(0xFFBFDBFE),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeWidget()));
          } else if (index == 1) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => myAppointmentScreen()));
          } else if (index == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ChatRoom()));
          } else if (index == 3) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SettingScreen()));
          }
        },
      ),
    );
  }
}
