import 'dart:ffi';

import 'package:doctor_app/controllers/user/doctorInfoController.dart';
import 'package:doctor_app/screens/user/bookingAppointment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:intl/intl.dart';

class DoctorInfoScreen extends StatefulWidget {
  String doctorId;

  DoctorInfoScreen(this.doctorId);

  @override
  State<DoctorInfoScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorInfoScreen> {
  var controller = Get.put(DoctorInfoController());

  DateTime? selectedAppointment; //day for appointment

  DateTime? selectedTimeForAppointment; //time + day for appointment

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    controller.getDoctor(widget.doctorId, selectedAppointment);
    return GetX<DoctorInfoController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.blue),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Details Doctor',
                style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 23,
                    fontWeight: FontWeight.bold))),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    child: controller.doctor.value.avataId!.isNotEmpty
                        ? Image.network(
                            globals.url +
                                "/assets/" +
                                controller.doctor.value.avataId!,
                            headers: {
                              "authorization": "Bearer " + globals.token
                            },
                            height: 100,
                            fit: BoxFit.fitWidth,
                          )
                        : Image.asset(
                            'assets/logo/small_logo.png',
                            height: 100,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.doctor.value.firstName +
                            ' ' +
                            controller.doctor.value.lastName,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 250,
                        child: Text(
                          (controller.doctor.value.title ?? '') +
                              ' - ' +
                              controller.doctor.value.location,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            AppointmentList(context),
            SizedBox(
              height: 25,
            ),
            workingTimeWidget(context),
            SizedBox(
              height: 25,
            ),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About Doctor',
                        style: TextStyle(
                            color: Colors.indigo.shade900,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      controller.doctor.value.description!,
                      style: TextStyle(fontSize: 16),
                    )
                  ]),
            ),
          ]),
        ),
        bottomNavigationBar: bottomBookAppointmentButton(context),
      ),
    );
  }

  //get list of working-time
  Widget workingTimeWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Working time',
          style: TextStyle(
              color: Colors.indigo.shade900,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.timesForAppointment.value.length,
              itemBuilder: (BuildContext context, int index) {
                return workingTimeItem(context, index);
              }),
        )
      ]),
    );
  }

  //Working-time item
  Widget workingTimeItem(BuildContext context, int index) {
    bool selected = (selectedTimeForAppointment ==
        controller.timesForAppointment.value[index]);

    final DateFormat formatter = DateFormat('HH:mm');
    return GestureDetector(
      onTap: () {
        selectTimeForAppointment(controller.timesForAppointment.value[index]);
      },
      child: Row(
        children: [
          Container(
            width: 100,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: selected ? Colors.pink : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
              // border: Border.all(color: selected ? Colors.blue : Colors.transparent)
            ),
            child: Center(
              child: Text(
                '${formatter.format(controller.timesForAppointment.value[index])}',
                // '${controller.workingTime.value[index].day.toUpperCase()}, ${formatter.format(controller.workingTime.value[index].startTime)} - ${formatter.format(controller.workingTime.value[index].endTime)}',
                style: TextStyle(
                    fontSize: 16,
                    color: selected ? Colors.white : Colors.grey.shade600),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  // //Create list for appointments
  Widget AppointmentList(BuildContext context) {
    return Container(
      height: 150,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              style: TextStyle(
                  color: Colors.indigo.shade900,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 90,
              child: Flexible(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                      // border: Border.all(color: selected ? Colors.blue : Colors.transparent)
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.daysForAppointments.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return timeAppointmentItem(
                              context, index, controller);
                        }),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  /*
  Appointment time item
  */
  Widget timeAppointmentItem(BuildContext context, int index, var controller) {
    bool selected =
        (selectedAppointment == controller.daysForAppointments.value[index]);

    return GestureDetector(
      onTap: () {
        selectAppointment(controller.daysForAppointments.value[index]);
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              // border: Border.all(color: selected ? Colors.blue : Colors.transparent)
            ),
            width: 50,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      DateFormat('dd')
                          .format(controller.daysForAppointments.value[index]),
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              selected ? Colors.white : Colors.indigo.shade900,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    DateFormat('EEEE')
                        .format(controller.daysForAppointments.value[index])
                        .toString()
                        .substring(0, 3),
                    style: TextStyle(
                        fontSize: 16,
                        color: selected ? Colors.white : Colors.grey.shade600),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  /*
  when clicking appointment time
  */
  void selectAppointment(DateTime day) {
    selectedTimeForAppointment = null;
    if (selectedAppointment == null) {
      selectedAppointment = day;
    } else if (selectedAppointment != day) {
      selectedAppointment = day;
    } else {
      selectedAppointment = null;
    }

    controller.getTimeForEachWorkingDay(selectedAppointment);
    setState(() {});
  }

  void selectTimeForAppointment(DateTime day) {
    //time for selected day
    if (selectedTimeForAppointment == null) {
      selectedTimeForAppointment = day;
    } else if (selectedTimeForAppointment != day) {
      selectedTimeForAppointment = day;
    } else {
      selectedTimeForAppointment = null;
    }

    setState(() {});
  }

  Widget bottomBookAppointmentButton(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ElevatedButton(
          onPressed:
              selectedAppointment == null || selectedTimeForAppointment == null
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingAppointmentScreen(
                                doctor: controller.doctor.value,
                                time: selectedTimeForAppointment),
                          ));
                    },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text('Book Appointment',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
