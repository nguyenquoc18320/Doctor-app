import 'dart:convert';
import 'dart:io';

import 'package:doctor_app/models/specialist.dart';
import 'package:doctor_app/models/user.dart';
import 'package:doctor_app/screens/doctor/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/api_helper.dart' as api_helper;
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
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

  var addressTextController =
      TextEditingController(text: globals.user!.location);

  var descriptionTextController =
      TextEditingController(text: globals.user!.description);

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
        addressTextController.text.isEmpty ||
        descriptionTextController.text.isEmpty ||
        selectedSpecialist == null) {
      disableButton = true;
    } else {
      disableButton = false;
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSelectedSpecialist();
  }

  List<Specialist> specialistList = Specialist.getSpecialist();

  Specialist? selectedSpecialist;

  void getSelectedSpecialist() {
    for (Specialist s in specialistList) {
      if (s.name == (globals.user!.title)) {
        selectedSpecialist = s;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFulfillInfo();
    return Scaffold(
      backgroundColor: Color(0xFFEEEAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Update profile',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(top: 0, bottom: 50, right: 20, left: 20),
            child: Column(
              children: [
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: _avata_path.isEmpty != true
                        ? Image.file(
                            File(_avata_path),
                            height: 80,
                            width: 80,
                          )
                        : (globals.user!.avataId != null
                            ? Image.network(
                                (globals.url +
                                    "/assets/" +
                                    globals.user!.avataId!),
                                headers: {
                                  "authorization": "Bearer " + globals.token
                                },
                                height: 80,
                                width: 80,
                              )
                            : Image.asset(
                                'assets/logo/small_logo.png',
                                width: 80,
                                height: 80,
                              )),
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
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'First name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Last name',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  onChanged: (val) {
                    checkFulfillInfo();
                  },
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
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Address',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: partDistance,
                ),
                Row(children: [
                  Text(
                    'Specialist',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: DropdownButton<Specialist>(
                          value: selectedSpecialist,
                          items: specialistList.map((Specialist value) {
                            return DropdownMenuItem<Specialist>(
                              value: value,
                              child: Text(
                                value.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                          onChanged: (Specialist? value) {
                            setState(() {
                              selectedSpecialist = value!;
                              checkFulfillInfo();
                            });
                          },
                          hint: Text(
                            'Specialist',
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
                TextField(
                  controller: descriptionTextController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'About',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  minLines: 3,
                  maxLines: null,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            )),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF8856EB),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: disableButton ? null : () => confirm(),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
          )),
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
      'avatar': imageId,
      'title': selectedSpecialist != null ? selectedSpecialist!.name : '',
      'description': descriptionTextController.text
    };

    var response = await api_helper.patch("/users/me", json);

    print(response.body);

    if (response.statusCode == 200) {
      globals.user = User.fromJson(jsonDecode(response.body)['data']);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingScreen()),
      );
    } else {
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) => AlertDialog(
      //           title: Text('Info'),
      //           content: Text('Error! Please try later'),
      //           actions: <Widget>[
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.pop(context, false);
      //               },
      //               child: const Text('OK'),
      //             ),
      //           ],
      //         ));
    }
  }
}
