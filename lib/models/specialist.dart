import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Specialist {
  String name;
  Color color;
  var icon;

  Specialist({required this.name, required this.color, required this.icon});

  static List<Specialist> getSpecialist() {
    return [
      Specialist(
          name: 'Dental Specialist',
          color: Colors.blue,
          icon: FontAwesomeIcons.tooth),
      Specialist(
          name: 'Eye Specialist',
          color: Colors.yellowAccent.shade700,
          icon: FontAwesomeIcons.eye),
      Specialist(
          name: 'Cardio Specialist',
          color: Colors.pink.shade400,
          icon: FontAwesomeIcons.heartPulse),
      Specialist(
          name: 'Paeditric Specialist',
          color: Colors.lightGreen,
          icon: FontAwesomeIcons.child),
      Specialist(
          name: 'Brain Specialist',
          color: Colors.yellow.shade700,
          icon: FontAwesomeIcons.brain)
    ];
  }
}
