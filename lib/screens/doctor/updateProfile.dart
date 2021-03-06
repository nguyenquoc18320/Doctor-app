import 'dart:convert';
import 'dart:io';

import 'package:doctor_app/models/specialist.dart';
import 'package:doctor_app/models/user.dart';
import 'package:doctor_app/screens/doctor/settings.dart';
import 'package:doctor_app/widgets/base/TextFieldPrimary.dart';
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
        initialDate: birthdate ?? DateTime.now(),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: _avata_path.isEmpty != true
                        ? Image.file(
                            File(_avata_path),
                            height: 124,
                            width: 124,
                          )
                        : (globals.user!.avataId != null
                            ? Image.network(
                                (globals.url +
                                    "/assets/" +
                                    globals.user!.avataId!),
                                headers: {
                                  "authorization": "Bearer " + globals.token
                                },
                                height: 124,
                                width: 124,
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
                  height: 16,
                ),
                // TextFieldPrimary(
                //   title: 'First name',
                //   textController: firstNameTextController,
                //   cb_change: (val) {
                //     checkFulfillInfo();
                //   },
                // ),
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
                  height: 8,
                ),
                // TextFieldPrimary(
                //   title: 'Last name',
                //   textController: lastNameTextController,
                //   cb_change: (val) {
                //     checkFulfillInfo();
                //   },
                // ),
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
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        birthdate == null
                            ? 'Birthday'
                            : DateFormat('dd-MM-yyyy').format(birthdate!),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: birthdate == null
                                ? Colors.grey.shade300
                                : Colors.black),
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
                // TextFieldPrimary(
                //   title: 'Address',
                //   textController: addressTextController,
                // ),
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
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: DropdownButton<Specialist>(
                          isExpanded: true,
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
                // TextFieldPrimary(
                //   title: 'About',
                //   textController: descriptionTextController,
                //   minLines: 3,
                //   maxLines: null,
                // ),
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
                  height: 32,
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
