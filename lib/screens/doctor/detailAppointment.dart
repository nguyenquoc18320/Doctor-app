import 'package:doctor_app/controllers/doctor/appointmentDetailController.dart';
import 'package:doctor_app/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatelessWidget {
  // const AppointmentDetail({ Key? key }) : super(key: key);
  int appointmentID;
  AppointmentDetailScreen(this.appointmentID);

  var controller = Get.put(AppointmentDetailController());

  bool openLoading = false;

  TextEditingController resultTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.getAppointment(appointmentID);

    return GetX<AppointmentDetailController>(builder: (_) {
      if (controller.message.value.isNotEmpty) {
        Future.delayed(Duration.zero, () {
          openLoading = true;
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text('Info'),
                    content: Text(controller.message.value),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                          controller.message.value = '';
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        });
      }

      if (controller.doneProcess.value && openLoading) {
        Navigator.of(context, rootNavigator: true).pop();
        openLoading = false;
      }

      return (controller.appointment.value == null ||
              controller.user.value == null)
          ? Scaffold()
          : Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text('Appointment Detail',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),
              body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                      child: controller
                                              .user.value!.avataId!.isNotEmpty
                                          ? Image.network(
                                              globals.url +
                                                  "/assets/" +
                                                  controller
                                                      .user.value!.avataId!,
                                              headers: {
                                                "authorization":
                                                    "Bearer " + globals.token
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
                                      width: 8,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.user.value!.firstName +
                                              ' ' +
                                              controller.user.value!.lastName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF2563EB),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          // width: 250,
                                          child: Text(
                                            controller.appointment.value!.status
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: controller
                                                                .appointment
                                                                .value!
                                                                .status ==
                                                            'pending' ||
                                                        controller
                                                                .appointment
                                                                .value!
                                                                .status ==
                                                            'cancel'
                                                    ? Colors.red
                                                    : Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 50,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.message,
                                        color: Colors.blue,
                                        size: 30,
                                      )),
                                )
                              ],
                            ),
                          );
                        }),
                        SizedBox(
                          height: 16,
                        ),
                        visitTimeWidget(),
                        SizedBox(
                          height: 16,
                        ),
                        patientInfoWidget(),
                        SizedBox(
                          height: 16,
                        ),
                        problemtWidget(),
                        SizedBox(
                          height: 16,
                        ),
                        resultWidget()
                      ])),
              bottomNavigationBar: bottombar(context),
            );
    });
  }

  Widget visitTimeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(width: 1.0, color: Colors.grey.shade300))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date & time information',
            style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 16,
                fontWeight: FontWeight.w700),
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
                        size: 25,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(controller.appointment.value!.time),
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
                    size: 25,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    controller.appointment.value!.time != null
                        ? DateFormat('HH:mm')
                            .format(controller.appointment.value!.time)
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
        ],
      ),
    );
  }

  Widget patientInfoWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient information',
            style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  'Full name',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
                ),
              ),
              SizedBox(width: 24),
              Text(
                ': ${controller.appointment.value!.name}',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  'Age',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
                ),
              ),
              SizedBox(width: 24),
              Text(
                ': ${controller.appointment.value!.age}',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  'Gender',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
                ),
              ),
              SizedBox(width: 24),
              Text(
                ': ${controller.appointment.value!.gender}',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget problemtWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Problem detail',
            style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            controller.appointment.value!.medicalCondition,
            style: TextStyle(fontSize: 14, color: Color(0xFF6A6A6A)),
          )
        ],
      ),
    );
  }

  Widget resultWidget() {
    if (controller.appointment.value!.status != 'accepted') {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnosis',
              style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              controller.appointment.value!.result ?? 'No result',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnosis',
              style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: resultTextController,
              decoration:
                  new InputDecoration.collapsed(hintText: 'Enter result'),
            )
          ],
        ),
      );
    }
  }

  Widget bottombar(BuildContext context) {
    Widget cancelWidget = SizedBox(
        width: 160,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text(
                          'Are you sure you want to cancel the appointment?',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                              openLoading = true;
                              loading(context);
                              controller.cancelAppointment();
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text(
                              'No',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                      ));
            },
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: Colors.red,
            ),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )));

    if (controller.appointment.value!.status == 'pending') {
      return BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                  'Are you sure you want to accept the appointment?',
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                      openLoading = true;
                                      loading(context);
                                      controller.acceptAppointment();
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Color(0xFF2563EB),
                    ),
                    child: Text(
                      'Approve',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))),
            cancelWidget
          ]),
        ),
      );
    }

    if (controller.appointment.value!.status == 'accepted') {
      return BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            cancelWidget,
            SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                  'Are you sure you want to complete the appointment?',
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                      openLoading = true;
                                      loading(context);
                                      controller.doneAppointment(
                                          resultTextController.text);
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Color(0xFFFFC700),
                    ),
                    child: Text(
                      'Write diagnosis',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))),
          ]),
        ),
      );
    }
    return BottomAppBar();
  }
}
