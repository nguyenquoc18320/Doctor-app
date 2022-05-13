import 'package:doctor_app/models/workingtime.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/api_workingtime.dart' as workingtime_API;
import 'package:doctor_app/globals.dart' as globals;
import 'package:intl/intl.dart';

class WorkingTimeInfoController extends GetxController {
  var workingTimeList = <WorkingTime>[].obs;

  List<String> dayString = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  getWorkingTime() async {
    List<WorkingTime> tem_wk =
        await workingtime_API.getWorkingTimeByDoctorID(globals.user!.id ?? '');

    List<WorkingTime> sortList = [];

    for (String d in dayString) {
      for (WorkingTime wk in tem_wk) {
        if (d == wk.day) {
          sortList.add(wk);
          break;
        }
      }
    }
    workingTimeList.value = sortList;
  }
}
