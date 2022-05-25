import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/user.dart';
import 'package:doctor_app/screens/user/detailAppointment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Book Appointment',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date & time information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.calendarCheck,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.time != null
                                ? DateFormat('dd/MM/yyyy').format(widget.time!)
                                : "ERROR",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.clock,
                        color: Color(0xFFFF003D),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.time != null
                            ? DateFormat('HH:mm').format(widget.time!)
                            : "ERROR",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Patient's information",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              TextField(
                controller: fullNameTextController,
                decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 241, 240, 240),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    hintText: 'Full name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(57, 50, 50, 50),
                    )),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                onChanged: (String val) {
                  checkFulfillInfo();
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                  controller: ageTextController,
                  decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 241, 240, 240),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(color: Colors.transparent)),
                      hintText: 'Age',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(57, 50, 50, 50),
                      )),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  onChanged: (String val) {
                    checkFulfillInfo();
                  }),
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 241, 240, 240),
                  border: Border.all(
                      style: BorderStyle.solid,
                      width: 0.80,
                      color: Colors.transparent),
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
                                fontSize: 14, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(57, 50, 50, 50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Problem detail",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: problemTextController,
                decoration: const InputDecoration(
                    fillColor: Color.fromARGB(255, 241, 240, 240),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'What problem do you have?',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(57, 50, 50, 50),
                    )),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: null,
                onChanged: (String val) {
                  checkFulfillInfo();
                },
              ),
            ],
          ),
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
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ));
                    }
                  });
                },
          style: ButtonStyle(
              backgroundColor: disableButton
                  ? null
                  : MaterialStateProperty.all(Color(0xFf2563EB)),
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

    //check appointment exists or not
    List<Appointment> existedAppointment =
        await API_appointment.getAppointmentOfDoctorByTime(
            widget.doctor.id!, widget.time!);

    if (existedAppointment.length > 0) {
      setState(() {
        errorMessage = 'The appointment was booked. Please select other time!';
      });
      return errorMessage;
    } else {
      Appointment? createdAppointment =
          await API_appointment.createAppointment(appointment);

      if (createdAppointment == null) {
        // show error alert dialog

        setState(() {
          errorMessage = 'Unsuccessfully!';
        });
      } else {
        // setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailAppointmentScreen(
                      appointmentId: createdAppointment.id,
                    )));
        // });
      }
      return errorMessage;
    }
  }
}
