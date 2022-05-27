import 'package:flutter/material.dart';

class InputSearch extends StatelessWidget {
  String title;
  final textController;
  VoidCallback cb_tap;
  InputSearch({
    Key? key,
    required this.title,
    required this.textController,
    required this.cb_tap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        cb_tap();
      },
      controller: textController,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFFFFFFF),
        hintText: title,
        hintStyle: TextStyle(color: Colors.black38),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
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
