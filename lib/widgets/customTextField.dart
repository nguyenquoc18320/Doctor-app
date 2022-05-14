import 'dart:ffi';

import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  String title;
  bool isPassword = false;
  final textController;

  final String? Function(String)? validator; //

  MyTextFormField(
      {Key? key,
      required this.title,
      this.isPassword = false,
      required this.textController,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      obscureText: isPassword,
      validator: (value) => validator!(value!),
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(243, 243, 243, 1),
        hintText: title,
        hintStyle: TextStyle(color: Colors.black38),
        border: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2.0, color: Color.fromRGBO(243, 243, 243, 1)),
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
