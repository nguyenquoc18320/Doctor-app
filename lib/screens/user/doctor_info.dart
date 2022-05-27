import 'dart:ffi';

import 'package:doctor_app/controllers/user/doctorInfoController.dart';
import 'package:doctor_app/screens/user/bookingAppointment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          backgroundColor: Color(0xffEEEAFB),
          elevation: 0.0,
          foregroundColor: Color(0xFF4702A2),
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Details Doctor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () {}, icon: FaIcon(FontAwesomeIcons.commentDots))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(32),
            //     topRight: Radius.circular(32),
            //   ),
            // ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              LayoutBuilder(builder: (context, BoxConstraints constraints) {
                return Container(
                  width: constraints.maxWidth,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: controller.doctor.value.avataId!.isNotEmpty
                            ? Image.network(
                                globals.url +
                                    "/assets/" +
                                    controller.doctor.value.avataId!,
                                headers: {
                                  "authorization": "Bearer " + globals.token
                                },
                                height: 80,
                                width: 80,
                              )
                            : Image.asset(
                                'assets/logo/small_logo.png',
                                height: 80,
                                width: 80,
                              ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: (constraints.maxWidth - 100) * 0.9,
                            child: Text(
                              'Dr. ' +
                                  controller.doctor.value.firstName +
                                  ' ' +
                                  controller.doctor.value.lastName,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            (controller.doctor.value.title ?? ''),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: (constraints.maxWidth - 100) * 0.9,
                            child: Text(
                              (controller.doctor.value.location),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(
                height: 24,
              ),
              statistic(),
              SizedBox(
                height: 36,
              ),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About',
                          style: TextStyle(
                              color: Color(0xff4702A2),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        controller.doctor.value.description!,
                      )
                    ]),
              ),
              SizedBox(
                height: 24,
              ),
              AppointmentList(context),
              SizedBox(
                height: 4,
              ),
              workingTimeWidget(context),
            ]),
          ),
        ),
        bottomNavigationBar: bottomBookAppointmentButton(context),
      ),
    );
  }

  //get list of working-time
  Widget workingTimeWidget(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 40,
        child: Expanded(
          child: ListView.builder(
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.timesForAppointment.value.length,
              itemBuilder: (BuildContext context, int index) {
                return workingTimeItem(context, index);
              }),
        ));
  }

  Widget statistic() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  FontAwesomeIcons.userGroup,
                  size: 24,
                  color: Color(0xFF00D186),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(controller.numPatients.value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(' Patients', style: TextStyle(fontSize: 16))
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  FontAwesomeIcons.solidStar,
                  size: 24,
                  color: Color(0xFFFFC700),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(controller.star.value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(' Review', style: TextStyle(fontSize: 16))
            ],
          ),
        ),
      ],
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
            width: 80,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: selected ? Color(0xFF8856EB) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              // border: Border.all(color: selected ? Colors.blue : Colors.transparent)
            ),
            child: Center(
              child: Text(
                '${formatter.format(controller.timesForAppointment.value[index])}',
                // '${controller.workingTime.value[index].day.toUpperCase()}, ${formatter.format(controller.workingTime.value[index].startTime)} - ${formatter.format(controller.workingTime.value[index].endTime)}',
                style: TextStyle(
                    fontSize: 16,
                    color: selected ? Colors.white : Colors.black),
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
      height: 140,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Working Time',
                style: TextStyle(
                    color: Color(0xff4702A2),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              height: 90,
              child: Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // border: Border.all(color: selected ? Colors.blue : Colors.transparent)
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.daysForAppointments.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return timeAppointmentItem(context, index, controller);
                      }),
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
              color: selected ? Color(0xFF8856EB) : Colors.white,
              borderRadius: BorderRadius.circular(0),
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
                    height: 4,
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
              backgroundColor: selectedAppointment == null ||
                      selectedTimeForAppointment == null
                  ? null
                  : MaterialStateProperty.all(Color(0xFF8856EB)),
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
