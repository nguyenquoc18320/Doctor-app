import 'package:flutter/material.dart';

class TextFieldPrimary extends StatelessWidget {
  String title;
  bool isPassword = false;
  final textController;

  final String? Function(String)? validator; //

  TextFieldPrimary(
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
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        hintText: title,
        hintStyle: TextStyle(color: Colors.black38),
        border: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(40))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(40))),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
