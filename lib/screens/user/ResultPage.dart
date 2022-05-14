import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final result;
  const ResultPage({Key? key, required this.result}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.result),
      ),
    );
  }
}
