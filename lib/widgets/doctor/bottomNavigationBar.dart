import 'package:doctor_app/screens/doctor/appointments.dart';
import 'package:doctor_app/screens/doctor/settings.dart';
import 'package:doctor_app/screens/doctor/workingTimeInfo.dart';
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
          icon: Icon(FontAwesomeIcons.businessTime),
          label: 'WorkingTime',
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
        } else if (index == 1) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => WorkingTimeScreen()));
        } else if (index == 2) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DoctorAppointmentScreen()));
        } else if (index == 4) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SettingScreen()));
        }
      },
    );
  }
}
