import 'package:doctor_app/models/workingtime.dart';
import 'package:doctor_app/screens/doctor/editWorkingTime.dart';
import 'package:doctor_app/widgets/doctor/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doctor_app/controllers/doctor/workingTimeInfoController.dart';
import 'package:intl/intl.dart';

class WorkingTimeScreen extends StatelessWidget {
  var controller = Get.put(WorkingTimeInfoController());

  @override
  Widget build(BuildContext context) {
    controller.getWorkingTime();
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(
            'Working Time',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          )),
      body: GetX<WorkingTimeInfoController>(
        builder: (_) => Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 21),
          decoration: BoxDecoration(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Center(
                      child: Text(
                    'The working time will be applied for 7 next days',
                    style: TextStyle(fontSize: 16),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: controller.workingTimeList.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return eachWorkingTimeItem(
                            controller.workingTimeList.value[index]);
                      })
                ]),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditWorkingTimeScreen(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size.fromHeight(50), // NEW
                      ),
                      child: Text(
                        'Update Working Time',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                )
              ]),
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarCustom(currentIndex: 1),
    );
  }

  Widget eachWorkingTimeItem(WorkingTime workingtime) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xFF9E00FF),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            padding: EdgeInsets.symmetric(vertical: 8),
            width: 112,
            child: Center(
              child: Text(
                workingtime.day.toUpperCase(),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Text(
            '${DateFormat('HH:mm').format(workingtime.startTime)} - ${DateFormat('HH:mm').format(workingtime.endTime)}',
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
