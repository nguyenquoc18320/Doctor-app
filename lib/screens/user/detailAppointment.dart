import 'package:doctor_app/controllers/user/appointmentDetailsController.dart';
import 'package:doctor_app/screens/user/rateDoctor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:intl/intl.dart';

class DetailAppointmentScreen extends StatelessWidget {
  // const DetailAppointmentScreen({Key? key}) : super(key: key);
  int? appointmentId;
  var controller = Get.put(AppointmentDetailsController());

  DetailAppointmentScreen({Key? key, this.appointmentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.start(appointmentId ?? -1);

    Future.delayed(Duration.zero, () {
      if (controller.infoCancel.value == false) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Info'),
                  content: Text('Can not cancel the appointment!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                        controller.cancelAppointment();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    });

    return GetX<AppointmentDetailsController>(
      builder: (_) => (controller.appointment.value == null ||
              controller.doctor.value == null)
          ? Scaffold()
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text('Appointment detail',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),
              body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                            builder: (context, BoxConstraints constraints) {
                          return Container(
                            width: constraints.maxWidth,
                            color: Colors.white,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  child: controller
                                          .doctor.value!.avataId!.isNotEmpty
                                      ? Image.network(
                                          globals.url +
                                              "/assets/" +
                                              controller.doctor.value!.avataId!,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: (constraints.maxWidth - 80 - 50) *
                                          0.9,
                                      child: Text(
                                        'Dr. ' +
                                            controller.doctor.value!.firstName +
                                            ' ' +
                                            controller.doctor.value!.lastName,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF4702A2),
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      (controller.doctor.value!.title ?? ''),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Container(
                                      width: (constraints.maxWidth - 80 - 50) *
                                          0.9,
                                      child: Text(
                                        (controller.doctor.value!.location),
                                        style: TextStyle(fontSize: 12),
                                      ),
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
                                        FontAwesomeIcons.solidCommentDots,
                                        color: Color(0xFF4702A2),
                                        size: 30,
                                      )),
                                ),
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
                        resultWidget(),
                      ],
                    ),
                  )),
              bottomNavigationBar: cancelAppointmentButton(context),
            ),
    );
  }

  Widget visitTimeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date & time information',
            style: TextStyle(
                color: Color(0xFF4702A2),
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.calendarCheck,
                      color: Color(0xFF4702A2),
                      size: 25,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(controller.appointment.value!.time),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.clock,
                      color: Color(0xFFF59591),
                      size: 25,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      controller.appointment.value!.time != null
                          ? DateFormat('HH:mm')
                              .format(controller.appointment.value!.time)
                          : "ERROR",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
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
                color: Color(0xFF4702A2),
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Fullname',
                ),
              ),
              SizedBox(width: 24),
              Text(
                ': ${controller.appointment.value!.name}',
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Age',
                ),
              ),
              SizedBox(width: 24),
              Text(
                ': ${controller.appointment.value!.age}',
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Gender',
                ),
              ),
              SizedBox(width: 24),
              Text(
                ': ${controller.appointment.value!.gender}',
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
                color: Color(0xFF4702A2),
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            controller.appointment.value!.medicalCondition,
          )
        ],
      ),
    );
  }

  Widget resultWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Doctor's Diagnosis",
                style: TextStyle(
                    color: Color(0xFF4702A2),
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              controller.appointment.value!.result!.isNotEmpty
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF00D186),
                    )
                  : Icon(
                      Icons.error,
                      color: Color(0xFFFF003D),
                    )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            controller.appointment.value!.result!.isNotEmpty
                ? controller.appointment.value!.result!
                : 'No Diagnosis',
          )
        ],
      ),
    );
  }

  Widget cancelAppointmentButton(BuildContext context) {
    if (controller.appointment.value!.status == 'done') {
      return BottomAppBar(
        elevation: 0,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RatingScreen(controller.appointment.value!.id ?? -1),
                    ));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF8856EB)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Review',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            )),
      );
    }

    bool allowedCancel = false;

    if (controller.appointment.value != null &&
        controller.appointment.value!.status != 'cancel' &&
        controller.appointment.value!.status != 'done') {
      //you can cancel before 24hours of appointment time
      DateTime minusTime =
          controller.appointment.value!.time.subtract(Duration(days: 1));

      print(DateTime.now().compareTo(minusTime));

      if (DateTime.now().compareTo(minusTime) < 0) allowedCancel = true;
    }

    return BottomAppBar(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ElevatedButton(
          onPressed: allowedCancel
              ? () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Are you sure you want to cancel the appointment?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                  controller.cancelAppointment();
                                },
                                child: const Text('OK'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          ));
                }
              : null,
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text('Cancel Appointment',
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
