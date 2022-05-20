import 'package:doctor_app/controllers/doctor/appointmentDetailController.dart';
import 'package:doctor_app/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
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
        Navigator.pop(context);
        openLoading = false;
      }

      return (controller.appointment.value == null ||
              controller.user.value == null)
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
                                            .user.value!.avataId!.isNotEmpty
                                        ? Image.network(
                                            globals.url +
                                                "/assets/" +
                                                controller.user.value!.avataId!,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.user.value!.firstName +
                                            ' ' +
                                            controller.user.value!.lastName,
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
                                              color: controller.appointment
                                                              .value!.status ==
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
            DateFormat('EEEE, dd MMMM yyyy')
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
    if (controller.appointment.value!.status != 'accepted') {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal:
                    BorderSide(width: 1.0, color: Colors.grey.shade300))),
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
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal:
                    BorderSide(width: 1.0, color: Colors.grey.shade300))),
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
        width: 150,
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
                      primary: Colors.blue,
                    ),
                    child: Text(
                      'Accept',
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
                width: 150,
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
                      primary: Colors.blue,
                    ),
                    child: Text(
                      'Done',
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
