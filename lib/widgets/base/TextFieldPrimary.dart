import 'package:flutter/material.dart';

class TextFieldPrimary extends StatelessWidget {
  String title;
  bool isPassword = false;
  final textController;
  int? minLines;
  int? maxLines;
  final String? Function(String)? validator;
  final Function(String)? cb_change;

  TextFieldPrimary({
    Key? key,
    required this.title,
    this.isPassword = false,
    required this.textController,
    this.validator,
    this.cb_change,
    this.minLines,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      obscureText: isPassword,
      validator: (value) => validator!(value!),
      onChanged: (value) => cb_change!(value),
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      minLines: minLines,
      maxLines: maxLines,
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
