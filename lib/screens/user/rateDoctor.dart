import 'package:doctor_app/api/api_appointment.dart';
import 'package:doctor_app/controllers/user/ratingController.dart';
import 'package:doctor_app/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:get/get.dart';

class RatingScreen extends StatefulWidget {
  int? appoitmentid;
  // const RatingScreen({Key? key, String }) : super(key: key);
  RatingScreen(this.appoitmentid);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  var controller = Get.put(RatingController());

  TextEditingController commentTextController = TextEditingController();

  bool openLoading = false;

  int stars = 0;
  @override
  Widget build(BuildContext context) {
    controller.start(widget.appoitmentid ?? -1);
    return GetX<RatingController>(builder: (_) {
      if (controller.errorMessage.value.isNotEmpty) {
        Future.delayed(Duration.zero, () async {
          if (controller.doneProcessStatus.value && openLoading) {
            Navigator.pop(context);
            openLoading = false;
          }
        });
        Future.delayed(Duration.zero, () async {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text('Information'),
                    content: Text(controller.errorMessage.value),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          controller.errorMessage.value = '';
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      )
                    ],
                  ));
        });
      }

      return (controller.appointment.value == null ||
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20)),
                                        child: controller.doctor.value!.avataId!
                                                .isNotEmpty
                                            ? Image.network(
                                                globals.url +
                                                    "/assets/" +
                                                    controller
                                                        .doctor.value!.avataId!,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.doctor.value!.firstName +
                                                ' ' +
                                                controller
                                                    .doctor.value!.lastName,
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
                                              controller
                                                  .appointment.value!.status
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 16,
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
                                  )
                                ])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.star,
                                size: 40,
                                color: stars >= 1
                                    ? Colors.yellow.shade700
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  stars = 1;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.star,
                                size: 40,
                                color: stars >= 2
                                    ? Colors.yellow.shade700
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  stars = 2;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.star,
                                size: 40,
                                color: stars >= 3
                                    ? Colors.yellow.shade700
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  stars = 3;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.star,
                                size: 40,
                                color: stars >= 4
                                    ? Colors.yellow.shade700
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  stars = 4;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.star,
                                size: 40,
                                color: stars >= 5
                                    ? Colors.yellow.shade700
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  stars = 5;
                                });
                              },
                            )
                          ],
                        ),
                        Text(
                          "Comment",
                          style: TextStyle(fontSize: 16),
                        ),
                        TextField(
                          controller: commentTextController,
                        )
                      ])),
              bottomNavigationBar: bottomButton(context),
            );
    });
  }

  //
  Widget bottomButton(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text('Confirmation'),
                      content: Text(
                          'Are you sure you want to rate the appointment?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                            openLoading = true;
                            loading(context);
                            controller.rating(
                                stars, commentTextController.text);
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
}
