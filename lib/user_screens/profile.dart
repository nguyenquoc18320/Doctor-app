import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  //distance between label and textfield
  double labelDistance = 5;
  //distance between parts
  double partDistance = 15;

  //gender
  String gender = '';
  DateTime birthday = DateTime.now();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: birthday,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (picked != null && picked != birthday)
      setState(() {
        birthday = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              children: [
                Row(children: [
                  Image.asset('assets/logo/small_logo.jpg'),
                  Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ]),
                Image.asset(
                  'assets/logo/logo.jpg',
                  height: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Full name',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  height: labelDistance,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    hintText: 'Full name',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.grey[400]),
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: partDistance,
                ),
                Row(
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  height: labelDistance,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[400])),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: partDistance,
                ),
                Row(
                  children: [
                    Text(
                      'Gender',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  height: labelDistance,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: DropdownButton<String>(
                        value: (gender.isEmpty) ? null : gender,
                        items: <String>['Male', 'Female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                        hint: Text(
                          'Gender',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: partDistance,
                ),
                Row(
                  children: [
                    Text(
                      'Date of birth',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  height: labelDistance,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd-MM-yyyy').format(birthday),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: partDistance,
                ),
                Row(
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                SizedBox(
                  height: labelDistance,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      hintText: 'Address',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[400])),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
    );
  }
}
