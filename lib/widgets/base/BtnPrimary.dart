import 'package:flutter/material.dart';

class BtnPrimary extends StatelessWidget {
  String title;
  final VoidCallback pressFn;
  BtnPrimary({
    Key? key,
    required this.title,
    required this.pressFn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF212121),
          minimumSize: Size.fromHeight(50),
        ),
        onPressed: () => pressFn(),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
