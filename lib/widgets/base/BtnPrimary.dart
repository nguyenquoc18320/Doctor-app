import 'package:flutter/material.dart';

class BtnPrimary extends StatelessWidget {
  String title;
  final VoidCallback cb_press;
  BtnPrimary({
    Key? key,
    required this.title,
    required this.cb_press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       primary: Color(0xFF212121),
    //       minimumSize: Size.fromHeight(50),
    //     ),
    //     onPressed: () => pressFn(),
    //     child: Text(
    //       title,
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ));
    return Container(
        height: 56,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromRGBO(255, 143, 158, 1),
                // Color.fromRGBO(255, 188, 143, 1),
                Color(0xFF4702A2),
                Color(0xFF996eee),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(32.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF996eee).withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(2, 8),
              )
            ]),
        child: Center(
          child: GestureDetector(
            onTap: cb_press,
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.0,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
