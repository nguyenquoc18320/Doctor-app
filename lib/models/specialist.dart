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
          color: Color(0xFF0082FF),
          icon: FontAwesomeIcons.tooth),
      Specialist(
          name: 'Eye Specialist',
          color: Color(0xFFFFC700),
          icon: FontAwesomeIcons.eye),
      Specialist(
          name: 'Cardio Specialist',
          color: Color(0xFFFF003D),
          icon: FontAwesomeIcons.heartPulse),
      Specialist(
          name: 'Paeditric Specialist',
          color: Color(0xFF1FD8D8),
          icon: FontAwesomeIcons.child),
      Specialist(
          name: 'Brain Specialist',
          color: Color(0xFF7B61FF),
          icon: FontAwesomeIcons.brain)
    ];
  }
}
