import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/controllers/doctor/doctorAppointmentController.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/doctor.dart' as doctor_API;
import 'package:intl/intl.dart' show DateFormat;

import '../../widgets/doctor/bottomNavigationBar.dart';

class DoctorAppointmentScreen extends StatelessWidget {
  var controller = Get.put(DoctorAppointmentController());
  bool openLoading = false;

  @override
  Widget build(BuildContext context) {
    controller.getUpcommingAppointments(globals.user!.id!, 1);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: globals.user!.avataId != null
                    ? Image.network(
                        globals.url + "/assets/" + globals.user!.avataId!,
                        headers: {"authorization": "Bearer " + globals.token},
                        height: 50,
                      )
                    : Image.asset(
                        'assets/logo/small_logo.png',
                        width: 50,
                        height: 50,
                      )),
          ),
          Text(
            'My Appointments',
            style: TextStyle(
                fontSize: 20,
                color: Colors.indigo.shade900,
                fontWeight: FontWeight.bold),
          )
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GetX<DoctorAppointmentController>(
          builder: (_) {
            Future.delayed(Duration.zero, () async {
              if (controller.doneProcessStatus.value && openLoading) {
                Navigator.pop(context);
                openLoading = false;
              }
            });
            return Column(children: [
              setButton(context),
              SizedBox(
                height: 10,
              ),
              dayRange(),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.appointmentList.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        eachAppointment(context, controller, index),
                        SizedBox(
                          height: 20,
                        )
                      ]);
                    }),
              ),
            ]);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(currentIndex: 2),
    );
  }

  Future<Widget?> loading(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
  }

  //set buttons
  Widget setButton(BuildContext context) {
    var selected = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    )));

    var notSelected = ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Colors.blue),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 120,
          child: ElevatedButton(
              style: controller.isUpcomming.value ? selected : notSelected,
              onPressed: () {
                openLoading = true;
                loading(context);
                controller.getUpcommingAppointments(globals.user?.id ?? '', 1);
              },
              child: Text(
                'Upcomming',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: controller.isUpcomming.value
                        ? Colors.white
                        : Colors.blue),
              )),
        ),
        Container(
          width: 120,
          child: ElevatedButton(
              style: controller.past.value ? selected : notSelected,
              onPressed: () {
                openLoading = true;
                loading(context);
                controller.getPastAppointments(globals.user?.id ?? '', 1);
              },
              child: Text(
                'Past',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: controller.past.value ? Colors.white : Colors.blue),
              )),
        ),
        Container(
          width: 120,
          child: ElevatedButton(
              style: controller.canceled.value ? selected : notSelected,
              onPressed: () {
                openLoading = true;
                loading(context);
                controller.getCancleAppointments(globals.user?.id ?? '', 1);
              },
              child: Text(
                'Canceled',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        controller.canceled.value ? Colors.white : Colors.blue),
              )),
        )
      ],
    );
  }

/*
Day range in 7 days
*/
  Widget dayRange() {
    if (controller.isUpcomming.value == false) {
      return SizedBox();
    }
    List<DateTime> sevenDays = [];

    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);

    sevenDays.add(now);

    for (int i = 1; i < 7; i++) {
      sevenDays.add(now.add(Duration(days: i)));
    }

    return Container(
      height: 100,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        itemCount: sevenDays.length,
                        itemBuilder: (BuildContext context, int index) {
                          return eachDayItem(context, sevenDays[index]);
                        }),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  Widget eachDayItem(BuildContext context, DateTime day) {
    bool selected = false;

    if (controller.selectedDay.value.year == day.year &&
        controller.selectedDay.value.month == day.month &&
        controller.selectedDay.value.day == day.day) {
      selected = true;
    }

    return GestureDetector(
      onTap: () {
        openLoading = true;
        loading(context);
        selectingDayForAppointments(day);
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? Colors.pink.shade300 : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              // border: Border.all(color: selected ? Colors.blue : Colors.transparent)
            ),
            width: 50,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(DateFormat('dd').format(day),
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              selected ? Colors.white : Colors.indigo.shade900,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    DateFormat('EEEE').format(day).toString().substring(0, 3),
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
  selected date
  */
  selectingDayForAppointments(DateTime day) {
    controller.changDate(globals.user?.id! ?? '', 1, day);
  }

  /*
  widget for each appointment
  */
  Widget eachAppointment(BuildContext context, var controller, int index) {
    Appointment appointment = controller.appointmentList.value[index];

    List<User> userList = controller.userList.value;

    //get doctor info
    User? user;

    //get user
    for (int i = 0; i < userList.length; i++) {
      if (userList[i].id == appointment.userCreated) {
        user = userList[i];
        break;
      }
    }

    if (user == null) {
      print('No');
      return SizedBox(
        height: 0,
      );
    }

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => DetailAppointmentScreen(
        //               appointmentId: appointment.id,
        //             )));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300)),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
            child: user.avataId!.isNotEmpty
                ? Image.network(
                    globals.url + "/assets/" + user.avataId!,
                    headers: {"authorization": "Bearer " + globals.token},
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
                user.firstName + ' ' + user.lastName,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                appointment.status[0].toUpperCase() +
                    appointment.status.substring(1).toLowerCase(),
                style: TextStyle(
                    fontSize: 16,
                    color: appointment.status == 'accepted' ||
                            appointment.status == 'Done'
                        ? Colors.green
                        : Colors.red),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    DateFormat('HH:mm ').format(appointment.time),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900),
                  ),
                  Text(
                    dateString(appointment.time),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }

  //check whether being today
  String dateString(DateTime date) {
    if (controller.isUpcomming.value) {
      return '';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final aDate = DateTime(date.year, date.month, date.day);
    if (today == aDate)
      return 'Today';
    else if (tomorrow == aDate)
      return 'Tomorrow';
    else if (yesterday == aDate) return 'Yesterday';

    return DateFormat('dd-MM-yyyy').format(date);
  }
}
