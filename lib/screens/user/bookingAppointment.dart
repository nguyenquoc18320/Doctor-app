import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/api_appointment.dart' as API_appointment;

class BookingAppointmentScreen extends StatefulWidget {
  User doctor;
  DateTime? time;

  BookingAppointmentScreen({required this.doctor, required this.time});

  @override
  State<BookingAppointmentScreen> createState() =>
      _BookingAppointmentScreenState();
}

class _BookingAppointmentScreenState extends State<BookingAppointmentScreen> {
  TextEditingController fullNameTextController = TextEditingController(
      text: '${globals.user!.firstName} ${globals.user!.lastName} ');

  TextEditingController ageTextController = TextEditingController();
  TextEditingController problemTextController = TextEditingController();

  bool disableButton = true;

  String gender = '';

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    checkFulfillInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Book Appointment',
          style: TextStyle(
              fontSize: 25,
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Colors.grey.shade300)
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: widget.doctor.avataId!.isNotEmpty
                        ? Image.network(
                            globals.url + "/assets/" + widget.doctor.avataId!,
                            headers: {
                              "authorization": "Bearer " + globals.token
                            },
                            height: 150,
                            fit: BoxFit.fitWidth,
                          )
                        : Image.asset(
                            'assets/logo/small_logo.png',
                            height: 150,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Doctor: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${widget.doctor.firstName} ${widget.doctor.lastName}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.indigo.shade900,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Day: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.time != null
                                  ? DateFormat('EE dd-MM-yyyy')
                                      .format(widget.time!)
                                  : "ERROR",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.indigo.shade900,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Time: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.time != null
                                  ? DateFormat('HH:mm').format(widget.time!)
                                  : "ERROR",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.indigo.shade900,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ])
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Patient's full name",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                TextField(
                  controller: fullNameTextController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      hintText: 'Full name',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFD6D6D6),
                      )),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  onChanged: (String val) {
                    checkFulfillInfo();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Age",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                TextField(
                    controller: ageTextController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        hintText: 'Age',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD6D6D6),
                        )),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    onChanged: (String val) {
                      checkFulfillInfo();
                    }),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Gender",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(style: BorderStyle.solid, width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
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
                          // setState(() {
                          gender = value!;
                          checkFulfillInfo();
                          // });
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Write your problem",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Text(
                      '*',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                TextField(
                  controller: problemTextController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: 'Write your problem',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFD6D6D6),
                      )),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: null,
                  minLines: 3,
                  onChanged: (String val) {
                    checkFulfillInfo();
                  },
                ),
              ],
            ),
          ],
        ),
      )),
      bottomNavigationBar: bottomBookAppointmentButton(context),
    );
  }

  void checkFulfillInfo() {
    if (gender.isEmpty ||
        fullNameTextController.text.isEmpty ||
        ageTextController.text.isEmpty ||
        problemTextController.text.isEmpty) {
      disableButton = true;
    } else {
      disableButton = false;
    }

    setState(() {});
  }

  Widget bottomBookAppointmentButton(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ElevatedButton(
          onPressed: disableButton
              ? null
              : () {
                  bookAppointment().then((value) {
                    if (errorMessage.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text('Information'),
                                content: Text(errorMessage),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // {Navigator.pop(context, 'OK')
                                      int count = 0;
                                      Navigator.popUntil(context, (route) {
                                        return count++ == 2;
                                      });
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ));
                    }
                  });
                },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text('Confirm',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  showAlertDialogSuccess(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Info"),
      content: Text("Successfully!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Info"),
          content: Text("Successfully!"),
          actions: [
            okButton,
          ],
        );
      },
    );
  }

  //book appointment
  Future<String> bookAppointment() async {
    Appointment appointment = Appointment(
        id: 0,
        name: fullNameTextController.text,
        age: int.parse(ageTextController.text),
        gender: gender,
        userCreated: globals.user?.id ?? '',
        doctorId: widget.doctor.id ?? '',
        time: widget.time!,
        createdDate: DateTime.now(),
        status: 'pending',
        medicalCondition: problemTextController.text);

    Appointment? createdAppointment =
        await API_appointment.createAppointment(appointment);

    if (createdAppointment == null) {
      // show error alert dialog

      setState(() {
        errorMessage = 'Unsuccessfully!';
      });
    } else {
      setState(() {
        errorMessage = 'Successfully!';
      });
    }
    return errorMessage;
  }
}
