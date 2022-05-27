import 'dart:convert';
import 'dart:io';

import 'package:doctor_app/models/user.dart';
import 'package:doctor_app/screens/user/settings.dart';
import 'package:doctor_app/widgets/user/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/api_helper.dart' as api_helper;
import 'package:image_picker/image_picker.dart';

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
  String gender = globals.user!.gender.toLowerCase();
  DateTime? birthdate = globals.user!.birthdate;

  //disable button
  bool disableButton = true;

  //all text controller
  var firstNameTextController =
      TextEditingController(text: globals.user!.firstName);
  var lastNameTextController =
      TextEditingController(text: globals.user!.lastName);
  var emailTextController = TextEditingController(text: globals.user!.email);
  var addressTextController =
      TextEditingController(text: globals.user!.location);

  //image picker
  ImagePicker imagePicker = ImagePicker();
  String _avata_path = '';

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: birthdate!,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (picked != null && picked != birthdate)
      setState(() {
        birthdate = picked;
      });
  }

  /*
  check when typing on field to make sure all fields are fulfilled
  */
  void checkFulfillInfo() {
    if (gender.isEmpty ||
        firstNameTextController.text.isEmpty ||
        lastNameTextController.text.isEmpty ||
        emailTextController.text.isEmpty ||
        addressTextController.text.isEmpty) {
      disableButton = true;
    } else {
      disableButton = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    checkFulfillInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text('Update profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(top: 0, bottom: 50, right: 20, left: 20),
            child: Column(
              children: [
                GestureDetector(
                  child: _avata_path.isEmpty != true
                      ? Image.file(
                          File(_avata_path),
                          height: 124,
                        )
                      : Image.network(
                          globals.url + "/assets/" + globals.user!.avataId!,
                          headers: {"authorization": "Bearer " + globals.token},
                          height: 124,
                        ),
                  onTap: () async {
                    var source = ImageSource.gallery;
                    XFile? image = await imagePicker.pickImage(
                        source: source,
                        imageQuality: 50,
                        preferredCameraDevice: CameraDevice.front);

                    if (image != null) _avata_path = image.path;

                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: firstNameTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'First name',
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  onChanged: (val) {
                    checkFulfillInfo();
                  },
                ),
                SizedBox(
                  height: partDistance,
                ),
                TextField(
                  controller: lastNameTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Last name',
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  onChanged: (val) {
                    checkFulfillInfo();
                  },
                ),
                SizedBox(
                  height: partDistance,
                ),
                TextField(
                  readOnly: true,
                  enabled: false,
                  controller: emailTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: partDistance,
                ),
                Row(children: [
                  Text(
                    'Gender',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: DropdownButton<String>(
                          value: (gender.isEmpty) ? null : gender,
                          items: <String>['Male', 'Female'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value.toLowerCase(),
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
                              checkFulfillInfo();
                            });
                          },
                          hint: Text(
                            'Gender',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
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
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            birthdate == null
                                ? ''
                                : DateFormat('dd-MM-yyyy').format(birthdate!),
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
                  ],
                ),
                SizedBox(
                  height: partDistance,
                ),
                TextField(
                  controller: addressTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Address',
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF8856EB),
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: disableButton ? null : () => confirm(),
                    child: Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            )),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(currentIndex: 3),
    );
  }

  void confirm() async {
    String imageId = globals.user!.avataId ?? '';
    //upload image
    if (_avata_path.isNotEmpty) {
      imageId = await api_helper.uploadFile(_avata_path);
    }

    var myFormat = DateFormat('yyyy-MM-dd');

    Map<String, String> json = {
      'first_name': firstNameTextController.text,
      'last_name': lastNameTextController.text,
      'gender': gender,
      'location': addressTextController.text,
      'birthdate': myFormat.format(birthdate!),
      'avatar': imageId
    };

    var response = await api_helper.patch("/users/me", json);

    print(response.body);

    if (response.statusCode == 200) {
      globals.user = User.fromJson(jsonDecode(response.body)['data']);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingScreen()),
      );
    }
  }
}
