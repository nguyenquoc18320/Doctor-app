import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/user.dart';
import 'package:doctor_app/screens/user/detailAppointment.dart';
import 'package:doctor_app/widgets/user/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/controllers/user/myAppointmentController.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/doctor.dart' as doctor_API;
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class myAppointmentScreen extends StatelessWidget {
  var controller = Get.put(MyAppointmentController());

  bool openLoading = false;

  @override
  Widget build(BuildContext context) {
    controller.getUpcommingAppointments(globals.user!.id!, 1);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffEEEAFB),
        automaticallyImplyLeading: false,
        title: Row(children: [
          Text(
            'My Appointments',
            style: TextStyle(
                color: Color(0xff4702A2), fontWeight: FontWeight.w700),
          )
        ]),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GetX<MyAppointmentController>(
          builder: (_) {
            Future.delayed(Duration.zero, () async {
              if (controller.doneProcessStatus.value && openLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                openLoading = false;
              }
            });
            return Column(children: [
              setButton(context),
              SizedBox(
                height: 16,
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
      bottomNavigationBar: BottomNavigationBarCustom(currentIndex: 1),
    );
  }

  Future<Widget?> loading(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.blue,
            ),
            SizedBox(
              width: 10,
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 16,
              ),
              child: Text(
                "Loading...",
              ),
            ),
          ],
        );
        // );
      },
    );
  }

  //set buttons
  Widget setButton(BuildContext context) {
    var selected = BoxDecoration(
        color: Colors.transparent,
        border: Border(bottom: BorderSide(color: Color(0xFF4702A2))));

    var notSelected = BoxDecoration(color: Color(0xFFEEEAFB));

    var elevatedButtonLayout = ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent));

    return LayoutBuilder(builder: ((context, constraints) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: controller.isUpcomming.value ? selected : notSelected,
              width: constraints.maxWidth * 0.33,
              child: ElevatedButton(
                  style: elevatedButtonLayout,
                  onPressed: () {
                    openLoading = true;
                    loading(context);
                    controller.getUpcommingAppointments(
                        globals.user?.id ?? '', 1);
                  },
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.isUpcomming.value
                            ? Color(0xFF4702A2)
                            : Color(0xFF52525B)),
                  )),
            ),
            Container(
              width: constraints.maxWidth * 0.32,
              decoration: controller.past.value ? selected : notSelected,
              child: ElevatedButton(
                  style: elevatedButtonLayout,
                  onPressed: () {
                    openLoading = true;
                    loading(context);
                    controller.gePastAppointments(globals.user?.id ?? '', 1);
                  },
                  child: Text(
                    'Past',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.past.value
                            ? Color(0xFF4702A2)
                            : Color(0xFF52525B)),
                  )),
            ),
            Container(
              width: constraints.maxWidth * 0.32,
              decoration: controller.canceled.value ? selected : notSelected,
              child: ElevatedButton(
                  style: elevatedButtonLayout,
                  onPressed: () {
                    openLoading = true;
                    loading(context);
                    controller.getCancleAppointments(globals.user?.id ?? '', 1);
                  },
                  child: Text(
                    'Canceled',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.canceled.value
                            ? Color(0xFF4702A2)
                            : Color(0xFF52525B)),
                  )),
            )
          ],
        ),
      );
    }));
  }

/*
Day range in 7 days
*/
  Widget dayRange() {
    if (controller.isUpcomming == false) {
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
      height: 90,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 70,
              child: Flexible(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
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
              color: selected ? Color(0xFF8856EB) : Colors.transparent,
              borderRadius: BorderRadius.circular(0),
              // border: Border.all(color: selected ? Colors.blue : Colors.transparent)
            ),
            width: 50,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(DateFormat('dd').format(day),
                      style: TextStyle(
                          fontSize: 16,
                          color: selected ? Colors.white : Color(0xff4702A2),
                          fontWeight: FontWeight.bold)),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Text(
                    DateFormat('EEEE').format(day).toString().substring(0, 3),
                    style: TextStyle(
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

    List<User> doctorList = controller.doctorList.value;

    //get doctor info
    User? doctor;

    //get doctor
    for (int i = 0; i < doctorList.length; i++) {
      if (doctorList[i].id == appointment.doctorId) {
        doctor = doctorList[i];
        break;
      }
    }

    if (doctor == null) {
      return SizedBox(
        height: 0,
      );
    }

    return GestureDetector(
      onTap: () {},
      child: LayoutBuilder(builder: ((context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: constraints.maxWidth * 0.85,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFECECEC))),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: doctor!.avataId!.isNotEmpty
                      ? Image.network(
                          globals.url + "/assets/" + doctor.avataId!,
                          headers: {"authorization": "Bearer " + globals.token},
                          height: 72,
                          width: 72,
                          // fit: BoxFit.fitWidth,
                        )
                      : Image.asset(
                          'assets/logo/small_logo.png',
                          height: 72,
                          width: 72,
                          // fit: BoxFit.fitWidth,
                        ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: constraints.maxWidth * 0.85 - 108,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ' + doctor.firstName + ' ' + doctor.lastName,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        appointment.status[0].toUpperCase() +
                            appointment.status.substring(1).toLowerCase(),
                        style: TextStyle(
                            fontSize: 14,
                            color: appointment.status == 'accepted' ||
                                    appointment.status == 'done'
                                ? Colors.green
                                : Colors.red),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateString(appointment.time),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color(0xFFFFC700),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              DateFormat('HH:mm').format(appointment.time),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailAppointmentScreen(
                              appointmentId: appointment.id,
                            )));
              },
              icon: Icon(Icons.arrow_forward_ios),
              color: Color(0xFFB3B3B3),
            ),
          ],
        );
      })),
    );
  }

  //check whether being today
  String dateString(DateTime date) {
    if (controller.isUpcomming.value) {
      return DateFormat('MMMM dd, yyyy').format(date);
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

    return DateFormat('MMMM dd, yyyy').format(date);
  }
}
