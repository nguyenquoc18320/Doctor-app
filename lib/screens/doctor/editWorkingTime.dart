import 'package:doctor_app/controllers/doctor/editWorkingTimeController.dart';
import 'package:doctor_app/models/workingtime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditWorkingTimeScreen extends StatefulWidget {
  bool editting; //var to consider editting mode

  EditWorkingTimeScreen({Key? key, this.editting = false}) : super(key: key);

  @override
  State<EditWorkingTimeScreen> createState() => _EditWorkingTimeScreenState();
}

class _EditWorkingTimeScreenState extends State<EditWorkingTimeScreen> {
  bool status = true;

  var controller = Get.put(EditWorkingTimeController());

  var openLoading = false;

  @override
  void initState() {
    super.initState();

    controller.init();
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
          'Update Working Time',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetX<EditWorkingTimeController>(
        builder: (_) {
          if (controller.doneProcessStatus.value && openLoading) {
            Navigator.of(context, rootNavigator: true).pop();
            openLoading = false;
          }
          if (controller.errorMessage.value.isNotEmpty) {
            Future.delayed(Duration.zero, () async {
              if (controller.doneProcessStatus.value && openLoading) {
                Navigator.of(context, rootNavigator: true).pop();
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          )
                        ],
                      ));
            });
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(children: [
              ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: controller.workingTimeList.length,
                  itemBuilder: (context, index) =>
                      eachWorkingTimeItem(context, index))
            ]),
          );
        },
      ),
      bottomNavigationBar: bottomButton(context),
    );
  }

  Widget eachWorkingTimeItem(BuildContext context, int index) {
    WorkingTime wk = controller.workingTimeList.value[index];
    bool isOpen =
        controller.statusDays.value[index]; //working time opening or not

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterSwitch(
            activeText: wk.day.toUpperCase(),
            inactiveText: wk.day.toUpperCase(),
            showOnOff: true,
            valueFontSize: 14,
            width: 80,
            activeColor: Color(0xFF2563EB),
            value: controller.statusDays.value[index],
            onToggle: (val) {
              controller.statusDays.value[index] = val;
              setState(() {});
            },
          ),
          SizedBox(width: 30),
          GestureDetector(
            onTap: () {
              if (isOpen) selectTime(context, index, 'start');
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  DateFormat('HH:mm').format(wk.startTime),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isOpen ? Colors.black : Colors.grey[300]),
                )),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              if (isOpen) selectTime(context, index, 'end');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade800),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text(
                DateFormat('HH:mm').format(wk.endTime),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isOpen ? Colors.black : Colors.grey[300]),
              ),
            ),
          )
        ],
      ),
    );
  }

  selectTime(BuildContext context, int index, String timeFor) async {
    DateTime originalTime = controller.workingTimeList.value[index].startTime;
    if (timeFor == 'end')
      originalTime = controller.workingTimeList.value[index].endTime;

//open time selection
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: originalTime.hour, minute: originalTime.minute),
    );

    if (newTime != null) {
      if (timeFor == 'start') {
        controller.workingTimeList.value[index].startTime = DateTime(
            originalTime.year,
            originalTime.month,
            originalTime.day,
            newTime.hour,
            newTime.minute,
            0);
        setState(() {});
      } else if (timeFor == 'end') {
        DateTime originalTime = controller.workingTimeList.value[index].endTime;
        controller.workingTimeList.value[index].endTime = DateTime(
            originalTime.year,
            originalTime.month,
            originalTime.day,
            newTime.hour,
            newTime.minute,
            0);
        setState(() {});
      }
    }
  }

  ///bottom button
  Widget bottomButton(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text(
                          'Are you sure you want to edit working time?',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                              openLoading = true;
                              loading(context);
                              controller.editWorkingTime();
                            },
                            child: const Text(
                              'OK',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                        ],
                      ));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF2563EB)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('Confirm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )),
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
}
