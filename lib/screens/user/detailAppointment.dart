import 'package:doctor_app/controllers/user/appointmentDetailsController.dart';
import 'package:doctor_app/screens/user/rateDoctor.dart';
import 'package:flutter/material.dart';
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
              appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text('Appointment Details',
                      style: TextStyle(
                          color: Colors.indigo.shade900,
                          fontSize: 23,
                          fontWeight: FontWeight.bold))),
              body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue)),
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
                                          .doctor.value!.avataId!.isNotEmpty
                                      ? Image.network(
                                          globals.url +
                                              "/assets/" +
                                              controller.doctor.value!.avataId!,
                                          headers: {
                                            "authorization":
                                                "Bearer " + globals.token
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
                                      controller.doctor.value!.firstName +
                                          ' ' +
                                          controller.doctor.value!.lastName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      // width: 250,
                                      child: Text(
                                        controller.appointment.value!.status
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: controller.appointment.value!
                                                            .status ==
                                                        'pending' ||
                                                    controller.appointment
                                                            .value!.status ==
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      visitTimeWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      patientInfoWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      resultWidget(),
                    ],
                  )),
              bottomNavigationBar: cancelAppointmentButton(context),
            ),
    );
  }

  Widget visitTimeWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(width: 1.0, color: Colors.grey.shade300))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit time',
            style: TextStyle(
                color: Colors.indigo.shade900,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            DateFormat('EEEE, MMMM dd yyyy')
                .format(controller.appointment.value!.time),
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            DateFormat('HH:mm').format(controller.appointment.value!.time),
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget patientInfoWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(width: 1.0, color: Colors.grey.shade300))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient information',
            style: TextStyle(
                color: Colors.indigo.shade900,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Full name',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(
                ': ${controller.appointment.value!.name}',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Age',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(
                ': ${controller.appointment.value!.age}',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Gender',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(
                ': ${controller.appointment.value!.gender}',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Problem',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Text(': '),
              Flexible(
                child: Text(
                  '${controller.appointment.value!.medicalCondition}',
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.visible,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget resultWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(width: 1.0, color: Colors.grey.shade300))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Result',
            style: TextStyle(
                color: Colors.indigo.shade900,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            controller.appointment.value!.result ?? 'No result',
            style: TextStyle(fontSize: 16),
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
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Rating Appointment',
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
