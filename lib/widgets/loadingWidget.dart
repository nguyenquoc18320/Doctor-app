import 'package:flutter/material.dart';

Future<Widget?> loading(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.blue,
          ),
          SizedBox(
            width: 10,
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
            ),
            child: Text(
              "Loading...",
            ),
          ),
        ],
      );
      // );
    },
  );
}
